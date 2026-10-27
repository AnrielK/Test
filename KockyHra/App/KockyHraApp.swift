import SwiftUI

@main
struct KockyHraApp: App {
    @StateObject private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch gameState.currentScreen {
                case .menu:
                    MenuView()
                case .selectCat:
                    SelectCatView()
                case .dressUp:
                    DressUpView()
                case .feeding:
                    FeedingView()
                case .grooming:
                    GroomingView()
                case .litter:
                    LitterView()
                }
            }
            .environmentObject(gameState)
            .statusBarHidden(true)
        }
    }
}
