import SwiftUI

struct FeedingView: View {
    @EnvironmentObject var gameState: GameState
    @State private var plateFood: FoodType? = nil

    var body: some View {
        ZStack {
            StripedRoomBackground(
                baseColor: Color(red: 0.98, green: 0.78, blue: 0.88),
                stripeColor: Color(red: 0.95, green: 0.70, blue: 0.82),
                showTopCurtains: false,
                showKitchenCabinet: true
            )

            HStack(spacing: 0) {
                // Levý modrý teploměr sytosti
                ThermometerProgressBar(progress: gameState.hungerProgress)
                    .padding(.leading, 52)
                    .offset(y: 6)

                // Kočička ve žluté jídelní židličce + bublina přání
                ZStack {
                    // Opěradlo židličky
                    RoundedRectangle(cornerRadius: 42)
                        .fill(Color(red: 0.98, green: 0.84, blue: 0.28))
                        .frame(width: 210, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 34)
                                .fill(Color(red: 0.88, green: 0.62, blue: 0.18))
                                .padding(14)
                        )
                        .offset(y: -4)

                    // Kočička (horní polovina těla)
                    CatView(
                        catType: gameState.selectedCat,
                        outfit: gameState.currentOutfit,
                        showLowerBody: false
                    )
                    .offset(y: -14)

                    // Boční opěrky židličky
                    HStack(spacing: 162) {
                        HighchairArmrest()
                        HighchairArmrest()
                    }
                    .offset(y: 16)

                    // Pultík židličky s talířem
                    ZStack {
                        RoundedRectangle(cornerRadius: 34)
                            .fill(Color(red: 0.98, green: 0.84, blue: 0.28))
                            .frame(width: 244, height: 122)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color(red: 0.94, green: 0.76, blue: 0.22))
                                    .padding(10)
                            )

                        // Oválný bílý talíř
                        ZStack {
                            Ellipse()
                                .fill(Color.white)
                                .frame(width: 168, height: 84)
                                .shadow(color: .black.opacity(0.15), radius: 2, y: 3)
                            Ellipse()
                                .fill(Color(red: 0.72, green: 0.80, blue: 0.90))
                                .frame(width: 136, height: 64)

                            if let plateFood = plateFood {
                                FoodIconView(food: plateFood, size: 64)
                            }
                        }
                    }
                    .offset(y: 108)

                    // Myšlenková bublina s jídlem nad kočičkou
                    ThoughtBubbleFoodView(food: gameState.desiredFood)
                        .offset(x: 92, y: -132)
                }
                .frame(maxWidth: .infinity)
                .offset(y: 22)

                // Modrá otevřená lednička vpravo
                OpenFridgeView { chosenFood in
                    feedCat(chosenFood)
                }
            }

            // Tlačítko Domů vlevo nahoře
            VStack {
                HStack {
                    TopCircleButton(systemIcon: "house.fill") {
                        withAnimation {
                            gameState.currentScreen = .selectCat
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

    private func feedCat(_ food: FoodType) {
        withAnimation(.spring()) {
            plateFood = food
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            withAnimation {
                if food == gameState.desiredFood {
                    gameState.hungerProgress = min(1.0, gameState.hungerProgress + 0.25)
                } else {
                    gameState.hungerProgress = min(1.0, gameState.hungerProgress + 0.10)
                }
                plateFood = nil
                gameState.randomizeCraving()
            }
        }
    }
}

struct HighchairArmrest: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.98, green: 0.90, blue: 0.36))
            .frame(width: 48, height: 62)
            .overlay(
                HStack(spacing: 8) {
                    Circle().fill(Color.orange.opacity(0.45)).frame(width: 6, height: 6)
                    Circle().fill(Color.orange.opacity(0.45)).frame(width: 6, height: 6)
                }
                .offset(y: -14)
            )
    }
}

struct OpenFridgeView: View {
    let onSelectFood: (FoodType) -> Void

    var body: some View {
        ZStack(alignment: .top) {
            // Korpus ledničky
            RoundedRectangle(cornerRadius: 26)
                .fill(Color(red: 0.68, green: 0.90, blue: 1.0))
                .frame(width: 245, height: 340)
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color(red: 0.28, green: 0.74, blue: 0.98), lineWidth: 10)
                )

            VStack(spacing: 12) {
                // 1. police: Kuře a Steak
                FridgeShelfView(leftFood: .chicken, rightFood: .steak, onSelect: onSelectFood)
                // 2. police: Párek a Losos
                FridgeShelfView(leftFood: .sausage, rightFood: .salmon, onSelect: onSelectFood)
                // 3. police: Sýr a Ryba
                FridgeShelfView(leftFood: .cheese, rightFood: .fish, onSelect: onSelectFood)

                // Spodní šuplík ledničky
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.60, green: 0.86, blue: 0.98))
                    .frame(width: 216, height: 48)
                    .overlay(
                        Capsule()
                            .fill(Color(red: 0.42, green: 0.74, blue: 0.94))
                            .frame(width: 78, height: 8)
                    )
            }
            .padding(.top, 18)
        }
        .offset(x: 8, y: 24)
    }
}

struct FridgeShelfView: View {
    let leftFood: FoodType
    let rightFood: FoodType
    let onSelect: (FoodType) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.42, green: 0.76, blue: 0.98))
                .frame(width: 214, height: 68)

            Rectangle()
                .fill(Color(red: 0.25, green: 0.64, blue: 0.92))
                .frame(width: 214, height: 10)

            HStack(spacing: 28) {
                Button {
                    onSelect(leftFood)
                } label: {
                    FoodIconView(food: leftFood, size: 58)
                }
                .buttonStyle(.plain)

                Button {
                    onSelect(rightFood)
                } label: {
                    FoodIconView(food: rightFood, size: 58)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)
        }
    }
}
