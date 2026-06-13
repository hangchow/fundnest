import Foundation

public protocol ExchangeRateFetching: Sendable {
    func fetchRates(baseCurrency: Currency) async throws -> ExchangeRateTable
}

public enum ExchangeRateFetchError: Error, Equatable {
    case invalidResponse
}

public struct RemoteExchangeRateClient: ExchangeRateFetching {
    private let session: URLSession
    private let endpoint: URL

    public init(
        session: URLSession = .shared,
        endpoint: URL = URL(string: "https://open.er-api.com/v6/latest/CNY")!
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    public func fetchRates(baseCurrency: Currency = .cny) async throws -> ExchangeRateTable {
        let (data, _) = try await session.data(from: endpoint)
        let response = try JSONDecoder().decode(Response.self, from: data)
        guard response.result == "success" else {
            throw ExchangeRateFetchError.invalidResponse
        }

        var rates: [Currency: Decimal] = [:]
        for currency in Currency.allCases {
            guard let quoteRate = response.rates[currency.rawValue], quoteRate != 0 else {
                continue
            }
            // API rates are quote units per one CNY. The app stores each currency in CNY.
            rates[currency] = Decimal(1 / quoteRate)
        }
        rates[.cny] = 1

        return ExchangeRateTable(
            baseCurrency: baseCurrency,
            rates: rates,
            updatedAt: Date()
        )
    }
}

private struct Response: Decodable {
    let result: String
    let rates: [String: Double]
}
