import SwiftUI

struct AppBackground: View {
    var body: some View {
        Color.appBackground
            .ignoresSafeArea()
    }
}

struct TopBar<Trailing: View>: View {
    enum LeadingAction {
        case none
        case back(() -> Void)
    }

    let title: String
    let leading: LeadingAction
    @ViewBuilder let trailing: () -> Trailing

    init(
        title: String,
        leading: LeadingAction = .none,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.leading = leading
        self.trailing = trailing
    }

    var body: some View {
        ZStack {
            HStack {
                switch leading {
                case .none:
                    Spacer()
                        .frame(width: 58, height: 58)
                case .back(let action):
                    Button(action: action) {
                        Image(systemName: "chevron.left")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Color.brandBlue)
                            .frame(width: 58, height: 58)
                            .background(.white)
                            .clipShape(Circle())
                            .softShadow()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("返回")
                }

                Spacer()
                trailing()
            }

            Text(title)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .padding(.horizontal, 92)
        }
        .frame(height: 58)
    }
}

struct SectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
    }
}

struct HeaderCell: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SummaryCard: View {
    let amount: Decimal
    let currency: Currency
    let isEditable: Bool
    @Binding var selectedCurrency: Currency

    var body: some View {
        VStack(spacing: 22) {
            Text("当前总存款")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.secondaryText)

            HStack(alignment: .firstTextBaseline, spacing: 16) {
                Text(MoneyFormatter.currencyText(amount, currency: currency))
                    .font(.system(size: 58, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)

                Spacer(minLength: 12)

                if isEditable {
                    CurrencyPicker(selection: $selectedCurrency)
                } else {
                    Text(currency.localizedName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.ink)
                }
            }
        }
        .padding(.horizontal, 30)
        .frame(height: 166)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .softShadow()
    }
}

struct CurrencyPicker: View {
    @Binding var selection: Currency

    var body: some View {
        Menu {
            ForEach(Currency.allCases) { currency in
                Button(currency.localizedName) {
                    selection = currency
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selection.localizedName)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption.weight(.bold))
            }
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(Color.ink)
            .padding(.horizontal, 14)
            .frame(minWidth: 104, minHeight: 48)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

enum DateFormatters {
    static let settings: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    static let build: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        return formatter
    }()
}

extension View {
    func softShadow() -> some View {
        shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)
    }
}

extension Color {
    static let appBackground = Color(red: 0.965, green: 0.97, blue: 0.98)
    static let ink = Color(red: 0.035, green: 0.075, blue: 0.145)
    static let secondaryText = Color(red: 0.45, green: 0.49, blue: 0.58)
    static let brandBlue = Color(red: 0.03, green: 0.42, blue: 0.95)
    static let border = Color(red: 0.86, green: 0.88, blue: 0.92)
}
