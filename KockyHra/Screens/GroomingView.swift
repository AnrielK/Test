// Soubor: KockyHra/Screens/GroomingView.swift
import SwiftUI

struct GroomingView: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        ZStack {
            StripedRoomBackground(
                baseColor: Color(red: 0.82, green: 0.72, blue: 0.96),
                stripeColor: Color(red: 0.76, green: 0.64, blue: 0.92),
                showTopCurtains: true
            )

            HStack {
                ThermometerProgressBar(progress: gameState.groomingProgress)
                    .padding(.leading, 52)

                Spacer()

                CatView(catType: gameState.selectedCat, outfit: gameState.currentOutfit)
                    .onTapGesture {
                        withAnimation {
                            gameState.groomingProgress = min(1.0, gameState.groomingProgress + 0.25)
                        }
                    }

                Spacer()
            }

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
