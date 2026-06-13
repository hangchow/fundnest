import Foundation

public struct Project: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var name: String
    public var summaryCurrency: Currency
    public var accounts: [AccountEntry]
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        summaryCurrency: Currency,
        accounts: [AccountEntry] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.summaryCurrency = summaryCurrency
        self.accounts = accounts
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public mutating func touch(now: Date = Date()) {
        updatedAt = now
    }
}
