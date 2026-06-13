import Foundation

public struct ExchangeRate: Codable, Equatable, Sendable {
    public var baseCurrency: Currency
    public var quoteCurrency: Currency
    public var rate: Decimal
    public var updatedAt: Date

    public init(
        baseCurrency: Currency,
        quoteCurrency: Currency,
        rate: Decimal,
        updatedAt: Date = Date()
    ) {
        self.baseCurrency = baseCurrency
        self.quoteCurrency = quoteCurrency
        self.rate = rate
        self.updatedAt = updatedAt
    }
}
