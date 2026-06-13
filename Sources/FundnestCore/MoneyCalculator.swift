import Foundation

public enum MoneyCalculator {
    public static let displayScale: Int = 2

    public static func convertedAmount(
        _ amount: Decimal,
        from source: Currency,
        to target: Currency,
        using rates: ExchangeRateTable
    ) -> Decimal? {
        guard let rate = rates.rate(from: source, to: target) else {
            return nil
        }
        return amount * rate
    }

    public static func total(
        for project: Project,
        using rates: ExchangeRateTable
    ) -> Decimal {
        project.accounts.reduce(Decimal.zero) { partial, account in
            guard let converted = convertedAmount(
                account.amount,
                from: account.currency,
                to: project.summaryCurrency,
                using: rates
            ) else {
                return partial
            }
            return partial + converted
        }
        .rounded(scale: displayScale)
    }
}

private extension Decimal {
    func rounded(scale: Int) -> Decimal {
        var source = self
        var result = Decimal()
        NSDecimalRound(&result, &source, scale, .plain)
        return result
    }
}
