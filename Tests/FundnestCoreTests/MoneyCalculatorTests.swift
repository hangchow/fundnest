import Foundation
import Testing
@testable import FundnestCore

struct MoneyCalculatorTests {
    @Test func projectTotalConvertsAccountsToSummaryCurrency() {
        let rates = ExchangeRateTable(
            rates: [
                .cny: 1,
                .usd: 7,
                .hkd: Decimal(string: "0.9")!
            ]
        )
        let project = Project(
            name: "日本旅行",
            summaryCurrency: .cny,
            accounts: [
                AccountEntry(name: "人民币账户", amount: 100, currency: .cny),
                AccountEntry(name: "美元账户", amount: 10, currency: .usd),
                AccountEntry(name: "港币账户", amount: 100, currency: .hkd)
            ]
        )

        #expect(MoneyCalculator.total(for: project, using: rates) == Decimal(string: "260")!)
    }

    @Test func projectTotalCanConvertAwayFromBaseCurrency() {
        let rates = ExchangeRateTable(
            rates: [
                .cny: 1,
                .usd: 7,
                .hkd: Decimal(string: "0.9")!
            ]
        )
        let project = Project(
            name: "USD summary",
            summaryCurrency: .usd,
            accounts: [
                AccountEntry(name: "人民币账户", amount: 70, currency: .cny),
                AccountEntry(name: "美元账户", amount: 10, currency: .usd)
            ]
        )

        #expect(MoneyCalculator.total(for: project, using: rates) == Decimal(string: "20")!)
    }

    @Test func missingRateSkipsThatAccount() {
        let rates = ExchangeRateTable(rates: [.cny: 1])
        let project = Project(
            name: "Missing",
            summaryCurrency: .cny,
            accounts: [
                AccountEntry(name: "Known", amount: 100, currency: .cny),
                AccountEntry(name: "Unknown", amount: 10, currency: .usd)
            ]
        )

        #expect(MoneyCalculator.total(for: project, using: rates) == 100)
    }
}
