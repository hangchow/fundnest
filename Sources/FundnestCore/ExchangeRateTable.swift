import Foundation

public struct ExchangeRateTable: Codable, Equatable, Sendable {
    public var baseCurrency: Currency
    public var rates: [Currency: Decimal]
    public var updatedAt: Date

    public init(
        baseCurrency: Currency = .cny,
        rates: [Currency: Decimal] = Self.defaultRates,
        updatedAt: Date = Date()
    ) {
        self.baseCurrency = baseCurrency
        self.rates = rates
        self.updatedAt = updatedAt
    }

    public static let defaultRates: [Currency: Decimal] = [
        .cny: 1,
        .usd: Decimal(string: "7.20")!,
        .hkd: Decimal(string: "0.92")!,
        .jpy: Decimal(string: "0.05")!,
        .eur: Decimal(string: "7.80")!,
        .gbp: Decimal(string: "9.20")!
    ]

    public func rate(from source: Currency, to target: Currency) -> Decimal? {
        guard source != target else { return 1 }
        guard let sourceInBase = rates[source], let targetInBase = rates[target], targetInBase != 0 else {
            return nil
        }
        return sourceInBase / targetInBase
    }
}
