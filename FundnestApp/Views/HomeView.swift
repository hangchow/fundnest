import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @EnvironmentObject private var appState: FundnestAppState
    @State private var path: [Route] = []
    @State private var orderedProjects: [Project] = []
    @State private var draggingProject: Project?

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 18) {
                            Button {
                                let id = appState.addProject()
                                path.append(.project(id))
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(Color.brandBlue)
                                    .frame(width: 58, height: 58)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .softShadow()
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("新建项目")

                            Spacer(minLength: 0)

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

                        LazyVStack(spacing: 16) {
                            ForEach(orderedProjects) { project in
                                NavigationLink(value: Route.project(project.id)) {
                                    ProjectRow(
                                        name: project.name,
                                        amount: appState.total(for: project),
                                        currency: project.summaryCurrency
                                    )
                                }
                                .buttonStyle(.plain)
                                .onDrag {
                                    draggingProject = project
                                    return NSItemProvider(object: project.id.uuidString as NSString)
                                }
                                .onDrop(
                                    of: [UTType.text],
                                    delegate: ProjectDropDelegate(
                                        targetProject: project,
                                        projects: $orderedProjects,
                                        draggingProject: $draggingProject,
                                        onDropCompleted: persistProjectOrder
                                    )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 78)
                    .padding(.bottom, 32)
                }
            }
            .onAppear {
                orderedProjects = appState.projects
            }
            .onChange(of: appState.projects) { nextProjects in
                orderedProjects = nextProjects
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

    private func persistProjectOrder() {
        draggingProject = nil
        appState.reorderProjects(matching: orderedProjects.map(\.id))
    }
}

private enum Route: Hashable {
    case settings
    case project(Project.ID)
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

private struct ProjectDropDelegate: DropDelegate {
    let targetProject: Project
    @Binding var projects: [Project]
    @Binding var draggingProject: Project?
    let onDropCompleted: () -> Void

    func dropEntered(info: DropInfo) {
        guard
            let draggingProject,
            draggingProject.id != targetProject.id,
            let sourceIndex = projects.firstIndex(where: { $0.id == draggingProject.id }),
            let targetIndex = projects.firstIndex(where: { $0.id == targetProject.id })
        else {
            return
        }

        withAnimation(.snappy(duration: 0.18)) {
            let item = projects.remove(at: sourceIndex)
            projects.insert(item, at: targetIndex)
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        onDropCompleted()
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
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
