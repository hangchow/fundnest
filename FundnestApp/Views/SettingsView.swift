import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: FundnestAppState

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 32) {
                TopBar(title: "设置", leading: .back { dismiss() })

                VStack(alignment: .leading, spacing: 14) {
                    SectionTitle("应用偏好")

                    VStack(spacing: 0) {
                        HStack(spacing: 18) {
                            Text("默认货币")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color.ink)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            CurrencyPicker(selection: Binding(
                                get: { appState.settings.defaultCurrency },
                                set: { appState.setDefaultCurrency($0) }
                            ))
                        }
                        .padding(.vertical, 14)

                        Divider()

                        HStack(alignment: .center, spacing: 18) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("货币汇率")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(Color.ink)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("汇率加载时间：")
                                    Text(lastRefreshText)
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.82)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.secondaryText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Button {
                                Task { await appState.refreshRates() }
                            } label: {
                                Label(
                                    appState.isRefreshingRates ? "刷新中" : "手动刷新",
                                    systemImage: "arrow.clockwise"
                                )
                                .font(.system(size: 20, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.82)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.brandBlue)
                            .disabled(appState.isRefreshingRates)
                        }
                        .padding(.vertical, 16)
                    }
                    .padding(.horizontal, 18)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .softShadow()

                    if let error = appState.rateRefreshError {
                        Text(error)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    SectionTitle("关于")

                    VStack(spacing: 0) {
                        InfoRow(title: "版本号", value: appVersion)
                        Divider()
                        InfoRow(title: "打包时间", value: buildTime)
                    }
                    .padding(.horizontal, 18)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .softShadow()
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 68)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var lastRefreshText: String {
        guard let date = appState.settings.lastRateRefreshAt else {
            return "尚未刷新"
        }
        return DateFormatters.settings.string(from: date)
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildTime: String {
        Bundle.main.infoDictionary?["FUNDNEST_BUILD_TIME"] as? String ?? DateFormatters.build.string(from: Date())
    }
}

private struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.ink)
            Spacer()
            Text(value)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.secondaryText)
        }
        .frame(height: 72)
    }
}
