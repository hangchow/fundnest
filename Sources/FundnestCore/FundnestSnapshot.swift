import Foundation

public struct FundnestSnapshot: Codable, Equatable, Sendable {
    public var projects: [Project]
    public var settings: AppSettings
    public var exchangeRates: ExchangeRateTable

    public init(
        projects: [Project] = [],
        settings: AppSettings = AppSettings(),
        exchangeRates: ExchangeRateTable = ExchangeRateTable()
    ) {
        self.projects = projects
        self.settings = settings
        self.exchangeRates = exchangeRates
    }

    public static var sample: FundnestSnapshot {
        FundnestSnapshot(
            projects: [
                Project(
                    name: "日本旅行",
                    summaryCurrency: .cny,
                    accounts: [
                        AccountEntry(name: "招行卡", amount: 10_000, currency: .cny),
                        AccountEntry(name: "Wise", amount: 500, currency: .usd),
                        AccountEntry(name: "现金钱包", amount: 3_000, currency: .cny),
                        AccountEntry(name: "支付宝", amount: 3_500, currency: .hkd)
                    ]
                ),
                Project(
                    name: "相机升级",
                    summaryCurrency: .cny,
                    accounts: [
                        AccountEntry(name: "招行卡", amount: 5_000, currency: .cny),
                        AccountEntry(name: "Wise", amount: 500, currency: .usd)
                    ]
                ),
                Project(
                    name: "应急备用金",
                    summaryCurrency: .cny,
                    accounts: [
                        AccountEntry(name: "活期", amount: 35_000, currency: .cny)
                    ]
                ),
                Project(
                    name: "大阪工作室",
                    summaryCurrency: .cny,
                    accounts: [
                        AccountEntry(name: "租金账户", amount: 12_300, currency: .cny)
                    ]
                )
            ],
            settings: AppSettings(defaultCurrency: .cny),
            exchangeRates: ExchangeRateTable()
        )
    }
}
