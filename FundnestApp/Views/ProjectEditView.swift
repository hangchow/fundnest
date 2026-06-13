import SwiftUI

struct ProjectEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: FundnestAppState

    @State private var draft: Project

    init(project: Project) {
        _draft = State(initialValue: project)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 28) {
                    TopBar(
                        title: "",
                        leading: .back { dismiss() },
                        trailing: {
                            Button("完成") {
                                save()
                            }
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.brandBlue)
                        }
                    )

                    TextField("项目名称", text: $draft.name)
                        .font(.system(size: 34, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.ink)
                        .submitLabel(.done)
                        .padding(.horizontal, 28)

                    SummaryCard(
                        amount: MoneyCalculator.total(for: draft, using: appState.exchangeRates),
                        currency: draft.summaryCurrency,
                        isEditable: true,
                        selectedCurrency: $draft.summaryCurrency
                    )

                    EditableAccountTable(project: $draft)
                }
                .padding(.horizontal, 22)
                .padding(.top, 68)
                .padding(.bottom, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func save() {
        draft.name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if draft.name.isEmpty {
            draft.name = "未命名项目"
        }
        draft.accounts.removeAll {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && $0.amount == 0
        }
        appState.updateProject(draft)
        dismiss()
    }
}

private struct EditableAccountTable: View {
    @Binding var project: Project

    var body: some View {
        VStack(spacing: 0) {
            Grid(alignment: .leading, horizontalSpacing: 14, verticalSpacing: 0) {
                GridRow {
                    HeaderCell("账户")
                    HeaderCell("金额")
                    HeaderCell("货币")
                }
                .frame(height: 58)

                Divider()
                    .gridCellColumns(3)

                ForEach($project.accounts) { $account in
                    GridRow {
                        TextField("账户", text: $account.name)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 20))

                        TextField(
                            "金额",
                            value: $account.amount,
                            format: .number.precision(.fractionLength(0...2))
                        )
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 20))

                        CurrencyPicker(selection: $account.currency)
                    }
                    .frame(height: 76)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Button {
                project.accounts.append(
                    AccountEntry(
                        name: "",
                        amount: 0,
                        currency: project.summaryCurrency
                    )
                )
            } label: {
                Label("添加账户", systemImage: "plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color.brandBlue)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .softShadow()
    }
}
