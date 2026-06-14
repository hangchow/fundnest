import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: FundnestAppState
    @State private var isEditing = false

    let project: Project

    private var currentProject: Project {
        appState.projects.first(where: { $0.id == project.id }) ?? project
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 28) {
                    TopBar(
                        title: currentProject.name,
                        leading: .back { dismiss() },
                        trailing: {
                            Button("编辑") {
                                isEditing = true
                            }
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.brandBlue)
                        }
                    )

                    SummaryCard(
                        amount: appState.total(for: currentProject),
                        currency: currentProject.summaryCurrency,
                        isEditable: false,
                        selectedCurrency: .constant(currentProject.summaryCurrency)
                    )

                    AccountTable(project: currentProject)
                }
                .padding(.horizontal, 22)
                .padding(.top, 68)
                .padding(.bottom, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                ProjectEditView(project: currentProject) {
                    isEditing = false
                    dismiss()
                }
            }
            .presentationDetents([.large])
        }
    }
}

private struct AccountTable: View {
    let project: Project

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

                ForEach(project.accounts) { account in
                    GridRow {
                        BodyCell(account.name)
                        BodyCell(MoneyFormatter.amountText(account.amount))
                        BodyCell(account.currency.localizedName)
                    }
                    .frame(height: 78)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .softShadow()
    }
}

private struct BodyCell: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .medium))
            .foregroundStyle(Color.ink)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
