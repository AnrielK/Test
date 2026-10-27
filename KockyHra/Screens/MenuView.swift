import SwiftUI

struct MenuView: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        ZStack {
            QuiltedRoomBackground(
                wallColor: Color(red: 0.62, green: 0.38, blue: 0.86),
                lineColor: Color(red: 0.48, green: 0.24, blue: 0.74),
                curtainColor: Color(red: 0.76, green: 0.22, blue: 0.78)
            )

            // Škrabadlo vlevo vzadu
            ScratchingPostView()
                .offset(x: -210, y: -70)

            // Třpytky v pozadí
            SparkleView(size: 16).offset(x: -140, y: -90)
            SparkleView(size: 18).offset(x: 110, y: -110)

            // Žlutý pruhovaný koberec a kočička s klubíčkem
            ZStack {
                Ellipse()
                    .fill(Color(red: 0.96, green: 0.80, blue: 0.24))
                    .frame(width: 420, height: 185)
                    .overlay(
                        Ellipse()
                            .stroke(Color(red: 0.92, green: 0.70, blue: 0.16), lineWidth: 10)
                    )
                    .offset(y: 78)

                // Modré klubíčko vlevo
                YarnBallView(color: Color(red: 0.18, green: 0.48, blue: 0.92), size: 64)
                    .offset(x: -290, y: 56)

                // Bílá kočička hrající si s růžovým klubíčkem
                ZStack {
                    CatView(catType: .spotted, outfit: CatOutfit(), isWaving: true)
                        .rotationEffect(.degrees(18))
                        .scaleEffect(1.12)

                    YarnBallView(color: Color(red: 0.94, green: 0.22, blue: 0.62), size: 92)
                        .offset(x: -24, y: 12)
                }
                .offset(x: -30, y: -6)

                // Hračka myšky
                ToyMouseView()
                    .offset(x: 68, y: 82)
            }
            .offset(y: 20)

            // Velké modré tlačítko Play vpravo
            HStack {
                Spacer()
                BigPlayButton {
                    withAnimation(.easeInOut) {
                        gameState.currentScreen = .selectCat
                    }
                }
                .padding(.trailing, 54)
            }

            // Tlačítko nastavení vlevo nahoře
            VStack {
                HStack {
                    TopCircleButton(systemIcon: "gearshape.fill") {}
                        .padding(.leading, 22)
                        .padding(.top, 18)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
