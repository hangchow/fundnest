import Foundation
import Testing
@testable import FundnestCore

struct SnapshotCodingTests {
    @Test func snapshotRoundTripsProjectsSettingsAndRates() throws {
        let snapshot = FundnestSnapshot.sample
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let data = try encoder.encode(snapshot)
        let decoded = try decoder.decode(FundnestSnapshot.self, from: data)

        #expect(decoded.projects.count == snapshot.projects.count)
        #expect(decoded.projects.first?.accounts.count == snapshot.projects.first?.accounts.count)
        #expect(decoded.settings.defaultCurrency == snapshot.settings.defaultCurrency)
        #expect(decoded.exchangeRates.rates[.usd] == snapshot.exchangeRates.rates[.usd])
    }
}
