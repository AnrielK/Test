import SwiftUI

struct SelectCatView: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        ZStack {
            QuiltedRoomBackground(
                wallColor: Color(red: 0.56, green: 0.80, blue: 0.98),
                lineColor: Color(red: 0.28, green: 0.62, blue: 0.92),
                curtainColor: Color(red: 0.85, green: 0.26, blue: 0.78)
            )

            // Třpytky kolem kočiček
            SparkleView(size: 16).offset(x: -110, y: -60)
            SparkleView(size: 18).offset(x: 115, y: -75)
            SparkleView(size: 14).offset(x: 90, y: 40)

            // 3 kočičky na pódiích
            HStack(spacing: 42) {
                // 1. Zrzavobílá kočička (vlevo)
                CatStageSlot(
                    catType: .ginger,
                    outfit: gameState.outfits[.ginger] ?? CatOutfit(),
                    isWaving: true
                ) {
                    gameState.selectCat(.ginger)
                }
                .offset(y: -14)

                // 2. Hnědobílá kočička (uprostřed, mírně vpředu)
                CatStageSlot(
                    catType: .spotted,
                    outfit: gameState.outfits[.spotted] ?? CatOutfit(),
                    isWaving: false
                ) {
                    gameState.selectCat(.spotted)
                }
                .scaleEffect(1.06)
                .offset(y: 18)

                // 3. Šedá kočička v policejním (vpravo)
                CatStageSlot(
                    catType: .grey,
                    outfit: gameState.outfits[.grey] ?? CatOutfit.policePreset,
                    isWaving: false
                ) {
                    gameState.selectCat(.grey)
                }
                .offset(y: -14)
            }
            .offset(y: 18)

            // Tlačítko Domů vlevo nahoře
            VStack {
                HStack {
                    TopCircleButton(systemIcon: "house.fill") {
                        withAnimation {
                            gameState.currentScreen = .menu
                        }
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

struct CatStageSlot: View {
    let catType: CatType
    let outfit: CatOutfit
    let isWaving: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                StagePodium()
                    .offset(y: 96)

                CatView(catType: catType, outfit: outfit, isWaving: isWaving)
            }
        }
        .buttonStyle(.plain)
    }
}
