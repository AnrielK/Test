import SwiftUI

struct DressUpView: View {
    @EnvironmentObject var gameState: GameState
    @State private var selectedCategory: OutfitCategory = .hats

    var body: some View {
        ZStack {
            StripedRoomBackground(
                baseColor: Color(red: 0.92, green: 0.76, blue: 0.62),
                stripeColor: Color(red: 0.88, green: 0.70, blue: 0.55),
                showTopCurtains: true
            )

            HStack {
                // Kočička na fialovém krajkovém koberci
                ZStack {
                    ScallopedOvalCarpet()
                        .offset(y: 108)

                    CatView(
                        catType: gameState.selectedCat,
                        outfit: gameState.currentOutfit
                    )
                    .scaleEffect(1.08)
                }
                .frame(maxWidth: .infinity)
                .offset(x: -24, y: 18)

                // Pravý šatní panel se záložkami
                WardrobePanelView(
                    selectedCategory: $selectedCategory,
                    outfit: Binding(
                        get: { gameState.currentOutfit },
                        set: { gameState.currentOutfit = $0 }
                    )
                )
                .padding(.trailing, 24)
            }

            // Závěsné zelené tlačítko s fajfkou uprostřed nahoře
            VStack {
                HangingCheckButton {
                    withAnimation {
                        gameState.currentScreen = .feeding
                    }
                }
                Spacer()
            }
            .offset(x: -24)

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
}

struct WardrobePanelView: View {
    @Binding var selectedCategory: OutfitCategory
    @Binding var outfit: CatOutfit

    var body: some View {
        HStack(spacing: -6) {
            // 5 bočních záložek kategorií
            VStack(spacing: 8) {
                CategoryTabButton(icon: "baseball.cap.fill", isSelected: selectedCategory == .hats) {
                    selectedCategory = .hats
                }
                CategoryTabButton(icon: "tshirt.fill", isSelected: selectedCategory == .tops) {
                    selectedCategory = .tops
                }
                CategoryTabButton(icon: "figure.walk", isSelected: selectedCategory == .bottoms) {
                    selectedCategory = .bottoms
                }
                CategoryTabButton(icon: "shoe.fill", isSelected: selectedCategory == .shoes) {
                    selectedCategory = .shoes
                }
                CategoryTabButton(icon: "eyeglasses", isSelected: selectedCategory == .glasses) {
                    selectedCategory = .glasses
                }
            }
            .padding(.vertical, 14)
            .padding(.leading, 8)
            .padding(.trailing, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.25, green: 0.68, blue: 0.98))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 3))
            )

            // Hlavní mřížka 2x3 s položkami
            ZStack {
                RoundedRectangle(cornerRadius: 34)
                    .fill(Color(red: 0.78, green: 0.92, blue: 1.0))
                    .frame(width: 248, height: 320)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34)
                            .stroke(Color(red: 0.25, green: 0.68, blue: 0.98), lineWidth: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 34)
                            .stroke(Color.white, lineWidth: 3)
                    )

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.fixed(96), spacing: 14), GridItem(.fixed(96), spacing: 14)], spacing: 14) {
                        switch selectedCategory {
                        case .hats:
                            ForEach(HatType.allCases) { hat in
                                WardrobeItemCell(isSelected: outfit.hat == hat) {
                                    outfit.hat = (outfit.hat == hat) ? nil : hat
                                } content: {
                                    HatOverlayView(hat: hat)
                                        .scaleEffect(0.68)
                                }
                            }
                        case .tops:
                            ForEach(TopType.allCases) { top in
                                WardrobeItemCell(isSelected: outfit.top == top) {
                                    outfit.top = (outfit.top == top) ? nil : top
                                } content: {
                                    TopClothingView(top: top)
                                        .scaleEffect(0.75)
                                }
                            }
                        case .bottoms:
                            ForEach(BottomType.allCases) { bottom in
                                WardrobeItemCell(isSelected: outfit.bottom == bottom) {
                                    outfit.bottom = (outfit.bottom == bottom) ? nil : bottom
                                } content: {
                                    BottomClothingView(bottom: bottom)
                                        .scaleEffect(0.85)
                                }
                            }
                        case .shoes:
                            ForEach(ShoeType.allCases) { shoe in
                                WardrobeItemCell(isSelected: outfit.shoes == shoe) {
                                    outfit.shoes = (outfit.shoes == shoe) ? nil : shoe
                                } content: {
                                    CatFootView(shoe: shoe)
                                        .scaleEffect(1.4)
                                }
                            }
                        case .glasses:
                            ForEach(GlassesType.allCases) { glasses in
                                WardrobeItemCell(isSelected: outfit.glasses == glasses) {
                                    outfit.glasses = (outfit.glasses == glasses) ? nil : glasses
                                } content: {
                                    GlassesOverlayView(glasses: glasses)
                                        .scaleEffect(0.52)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 18)
                }
                .frame(width: 224, height: 296)
                .clipShape(RoundedRectangle(cornerRadius: 26))
            }
        }
    }
}

struct CategoryTabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color(red: 0.52, green: 0.88, blue: 0.28) : Color(red: 0.94, green: 0.45, blue: 0.78))
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 3)
                )
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
}

struct WardrobeItemCell<Content: View>: View {
    let isSelected: Bool
    let action: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 0.52, green: 0.82, blue: 0.98))
                    .frame(width: 94, height: 84)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(isSelected ? Color.yellow : Color(red: 0.36, green: 0.70, blue: 0.92), lineWidth: isSelected ? 4 : 2)
                    )

                content()
            }
        }
        .buttonStyle(.plain)
    }
}
