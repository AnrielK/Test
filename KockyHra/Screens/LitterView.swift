// Soubor: KockyHra/Screens/LitterView.swift
import SwiftUI

struct LitterView: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        ZStack {
            StripedRoomBackground(
                baseColor: Color(red: 0.76, green: 0.90, blue: 0.98),
                stripeColor: Color(red: 0.68, green: 0.84, blue: 0.95),
                showTopCurtains: false
            )

            CatView(catType: gameState.selectedCat, outfit: gameState.currentOutfit)

            VStack {
                HStack {
                    TopCircleButton(systemIcon: "house.fill") {
                        gameState.currentScreen = .selectCat
                    }
                    .padding(.leading, 22)
                    .padding(.top, 18)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
