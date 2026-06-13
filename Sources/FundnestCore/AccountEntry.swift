import Foundation

public struct AccountEntry: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var name: String
    public var amount: Decimal
    public var currency: Currency

    public init(
        id: UUID = UUID(),
        name: String,
        amount: Decimal,
        currency: Currency
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
    }
}
