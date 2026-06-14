import SwiftUI

struct ProjectEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: FundnestAppState

    @State private var draft: Project
    @State private var isShowingDeleteConfirmation = false

    let allowsDelete: Bool
    let onSave: (Project) -> Void
    let onDelete: () -> Void

    init(
        project: Project,
        allowsDelete: Bool = true,
        onDelete: @escaping () -> Void = {},
        onSave: @escaping (Project) -> Void = { _ in }
    ) {
        _draft = State(initialValue: project)
        self.allowsDelete = allowsDelete
        self.onDelete = onDelete
        self.onSave = onSave
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

                    EditableAccountTable(
                        project: $draft,
                        defaultAccountCurrency: appState.settings.defaultCurrency
                    )

                    if allowsDelete {
                        Button(role: .destructive) {
                            isShowingDeleteConfirmation = true
                        } label: {
                            Text("删除项目")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 68)
                .padding(.bottom, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog(
            "确认删除这个项目？",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("删除项目", role: .destructive) {
                deleteProject()
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("删除后无法恢复。")
        }
    }

    private func save() {
        draft.name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if draft.name.isEmpty {
            draft.name = "未命名项目"
        }
        draft.accounts.removeAll {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && $0.amount == 0
        }
        appState.saveProject(draft)
        onSave(draft)
        dismiss()
    }

    private func deleteProject() {
        appState.deleteProject(id: draft.id)
        onDelete()
    }
}

private struct EditableAccountTable: View {
    @Binding var project: Project
    let defaultAccountCurrency: Currency

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Color.clear
                        .frame(width: 34)
                    HeaderCell("账户")
                    HeaderCell("金额")
                        .frame(width: 78, alignment: .leading)
                    HeaderCell("货币")
                        .frame(width: 94, alignment: .leading)
                }
                .frame(height: 58)

                Divider()

                ForEach($project.accounts) { $account in
                    HStack(spacing: 8) {
                        Button {
                            project.accounts.removeAll { $0.id == account.id }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(Color.brandBlue)
                                .frame(width: 34, height: 44)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("删除账户")

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
                        .frame(width: 78)

                        CompactCurrencyPicker(selection: $account.currency)
                            .frame(width: 94)
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
                        currency: defaultAccountCurrency
                    )
                )
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2.weight(.semibold))
                    Text("添加账户")
                        .font(.headline)
                    Spacer(minLength: 0)
                }
                .font(.headline)
                .padding(.horizontal, 16)
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

private struct CompactCurrencyPicker: View {
    @Binding var selection: Currency

    var body: some View {
        Menu {
            ForEach(Currency.allCases) { currency in
                Button(currency.localizedName) {
                    selection = currency
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selection.localizedName)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2.weight(.bold))
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color.ink)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}
