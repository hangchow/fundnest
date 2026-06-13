import Foundation

public struct AppSettings: Codable, Equatable, Sendable {
    public var defaultCurrency: Currency
    public var lastRateRefreshAt: Date?

    public init(
        defaultCurrency: Currency = .cny,
        lastRateRefreshAt: Date? = nil
    ) {
        self.defaultCurrency = defaultCurrency
        self.lastRateRefreshAt = lastRateRefreshAt
    }
}
