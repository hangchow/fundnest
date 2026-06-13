import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: FundnestAppState
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Spacer()
                            NavigationLink(value: Route.settings) {
                                Image(systemName: "gearshape")
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(Color.ink)
                                    .frame(width: 58, height: 58)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .softShadow()
                            }
                            .accessibilityLabel("设置")
                        }

                        Button {
                            let id = appState.addProject()
                            path.append(.project(id))
                        } label: {
                            NewProjectCard()
                        }
                        .buttonStyle(.plain)

                        LazyVStack(spacing: 16) {
                            ForEach(appState.projects) { project in
                                NavigationLink(value: Route.project(project.id)) {
                                    ProjectRow(
                                        name: project.name,
                                        amount: appState.total(for: project),
                                        currency: project.summaryCurrency
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 78)
                    .padding(.bottom, 32)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .settings:
                    SettingsView()
                case .project(let id):
                    if let project = appState.projects.first(where: { $0.id == id }) {
                        ProjectDetailView(project: project)
                    } else {
                        MissingProjectView()
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

private enum Route: Hashable {
    case settings
    case project(Project.ID)
}

private struct NewProjectCard: View {
    var body: some View {
        HStack(spacing: 22) {
            Image(systemName: "plus")
                .font(.system(size: 42, weight: .regular))
                .foregroundStyle(Color.brandBlue)
                .frame(width: 86, height: 86)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text("新建项目")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Image("NestBird")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 110)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 28)
        .frame(height: 140)
        .background(
            LinearGradient(
                colors: [.brandBlue.opacity(0.55), .brandBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .softShadow()
    }
}

private struct ProjectRow: View {
    let name: String
    let amount: Decimal
    let currency: Currency

    var body: some View {
        HStack(spacing: 16) {
            Text(name)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(Color.ink)
                .lineLimit(1)

            Spacer(minLength: 12)

            Text("\(MoneyFormatter.amountText(amount)) \(currency.rawValue)")
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundStyle(Color.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Image(systemName: "chevron.right")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.secondaryText)
        }
        .padding(.horizontal, 24)
        .frame(height: 86)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .softShadow()
    }
}

private struct MissingProjectView: View {
    var body: some View {
        ZStack {
            AppBackground()
            Text("项目不存在")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.secondaryText)
        }
    }
}
