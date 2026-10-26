import SwiftUI

@main
struct KockyHraApp: App {
    @State private var game = GameState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(game)
        }
    }
}

struct RootView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        ZStack {
            screen
                .id(game.screen)
                .transition(.opacity)
        }
        .statusBarHidden()
        .persistentSystemOverlays(.hidden)
    }

    @ViewBuilder private var screen: some View {
        switch game.screen {
        case .select: SelectCatView()
        case .menu: MenuView()
        case .dressUp: DressUpView()
        case .feeding: FeedingView()
        case .litter: LitterView()
        case .grooming: GroomingView()
        }
    }
}
