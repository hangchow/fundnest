import Foundation

public enum Currency: String, CaseIterable, Codable, Identifiable, Sendable {
    case cny = "CNY"
    case usd = "USD"
    case hkd = "HKD"
    case jpy = "JPY"
    case eur = "EUR"
    case gbp = "GBP"

    public var id: String { rawValue }

    public var localizedName: String {
        switch self {
        case .cny:
            "人民币"
        case .usd:
            "美元"
        case .hkd:
            "港币"
        case .jpy:
            "日元"
        case .eur:
            "欧元"
        case .gbp:
            "英镑"
        }
    }

    public var symbol: String {
        switch self {
        case .cny:
            "¥"
        case .usd:
            "$"
        case .hkd:
            "HK$"
        case .jpy:
            "¥"
        case .eur:
            "€"
        case .gbp:
            "£"
        }
    }
}
