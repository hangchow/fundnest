import Foundation
import SwiftUI

@MainActor
final class FundnestAppState: ObservableObject {
    @Published private(set) var projects: [Project]
    @Published var settings: AppSettings
    @Published var exchangeRates: ExchangeRateTable
    @Published var isRefreshingRates = false
    @Published var rateRefreshError: String?

    private let persistence: SnapshotPersistence
    private let exchangeRateClient: ExchangeRateFetching

    init(
        persistence: SnapshotPersistence = SnapshotPersistence(),
        exchangeRateClient: ExchangeRateFetching = RemoteExchangeRateClient()
    ) {
        self.persistence = persistence
        self.exchangeRateClient = exchangeRateClient

        let snapshot = persistence.load() ?? .sample
        projects = snapshot.projects
        settings = snapshot.settings
        exchangeRates = snapshot.exchangeRates
    }

    func addProject() -> Project.ID {
        let project = Project(
            name: "新建项目",
            summaryCurrency: settings.defaultCurrency,
            accounts: [
                AccountEntry(name: "账户", amount: 0, currency: settings.defaultCurrency)
            ]
        )
        projects.insert(project, at: 0)
        persist()
        return project.id
    }

    func updateProject(_ project: Project) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            return
        }
        var nextProject = project
        nextProject.touch()
        projects[index] = nextProject
        persist()
    }

    func deleteProject(id: Project.ID) {
        projects.removeAll { $0.id == id }
        persist()
    }

    func setDefaultCurrency(_ currency: Currency) {
        settings.defaultCurrency = currency
        persist()
    }

    func total(for project: Project) -> Decimal {
        MoneyCalculator.total(for: project, using: exchangeRates)
    }

    func refreshRates() async {
        guard !isRefreshingRates else {
            return
        }

        isRefreshingRates = true
        rateRefreshError = nil
        defer { isRefreshingRates = false }

        do {
            exchangeRates = try await exchangeRateClient.fetchRates(baseCurrency: .cny)
            settings.lastRateRefreshAt = exchangeRates.updatedAt
            persist()
        } catch {
            rateRefreshError = "汇率刷新失败，请稍后重试"
        }
    }

    private func persist() {
        persistence.save(
            FundnestSnapshot(
                projects: projects,
                settings: settings,
                exchangeRates: exchangeRates
            )
        )
    }
}
