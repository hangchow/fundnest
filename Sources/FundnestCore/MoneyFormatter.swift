import Foundation

public enum MoneyFormatter {
    public static func amountText(
        _ amount: Decimal,
        fractionDigits: Int = 0
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = ","
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    public static func currencyText(
        _ amount: Decimal,
        currency: Currency,
        fractionDigits: Int = 0
    ) -> String {
        "\(currency.symbol) \(amountText(amount, fractionDigits: fractionDigits))"
    }
}
