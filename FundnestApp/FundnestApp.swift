import SwiftUI

@main
struct FundnestApp: App {
    @StateObject private var appState = FundnestAppState()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appState)
        }
    }
}
