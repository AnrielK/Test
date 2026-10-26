import SwiftUI

enum WardrobeCategory: CaseIterable, Identifiable {
    case hat, shirt, pants, shoes, glasses
    var id: Self { self }

    /// Oblast plátna kočičky, kterou ukazují náhledy.
    var region: CGRect {
        switch self {
        case .hat: CGRect(x: 55, y: -25, width: 205, height: 135)
        case .glasses: CGRect(x: 40, y: 95, width: 220, height: 110)
        case .shirt: CGRect(x: 60, y: 228, width: 180, height: 150)
        case .pants: CGRect(x: 70, y: 312, width: 160, height: 70)
        case .shoes: CGRect(x: 90, y: 340, width: 120, height: 56)
        }
    }

    var items: [WardrobeItem] {
        switch self {
        case .hat:
            Hat.allCases.map { h in
                WardrobeItem(id: h.rawValue, view: AnyView(h.view),
                             isWorn: { $0.hat == h }, toggle: { $0.hat = $0.hat == h ? nil : h })
            }
        case .glasses:
            Glasses.allCases.map { item in
                WardrobeItem(id: item.rawValue, view: AnyView(item.view),
                             isWorn: { $0.glasses == item }, toggle: { $0.glasses = $0.glasses == item ? nil : item })
            }
        case .shirt:
            Shirt.allCases.map { item in
                WardrobeItem(id: item.rawValue, view: AnyView(item.view),
                             isWorn: { $0.shirt == item }, toggle: { $0.shirt = $0.shirt == item ? nil : item })
            }
        case .pants:
            Pants.allCases.map { item in
                WardrobeItem(id: item.rawValue, view: AnyView(item.view),
                             isWorn: { $0.pants == item }, toggle: { $0.pants = $0.pants == item ? nil : item })
            }
        case .shoes:
            Shoes.allCases.map { item in
                WardrobeItem(id: item.rawValue, view: AnyView(item.view),
                             isWorn: { $0.shoes == item }, toggle: { $0.shoes = $0.shoes == item ? nil : item })
            }
        }
    }
}

struct WardrobeItem: Identifiable {
    let id: String
    let view: AnyView
    let isWorn: (Outfit) -> Bool
    let toggle: (inout Outfit) -> Void
}

/// Šatník: vlevo kočička na koberečku, vpravo skříňka s oblečením.
struct DressUpView: View {
    @Environment(GameState.self) private var game
    @State private var category: WardrobeCategory = .hat
    @State private var bounce = 0
    @State private var celebrate = false

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            let catX = w * 0.28
            ZStack {
                RoomBackground()

                Rug().frame(width: w * 0.38, height: h * 0.26)
                    .position(x: catX, y: h * 0.87)

                BoardView(height: h * 0.8) {
                    CatView(cat: game.cat, outfit: game.outfit, eyes: celebrate ? .happy : .open, mouthOpen: celebrate)
                }
                .phaseAnimator([0.0, 1.0], trigger: bounce) { view, phase in
                    view.scaleEffect(x: 1 + 0.05 * phase, y: 1 - 0.04 * phase, anchor: .bottom)
                }
                .position(x: catX, y: h * 0.55)

                SparkleBurst(trigger: bounce)
                    .position(x: catX, y: h * 0.45)

                HangingCheckButton(size: h * 0.17, rope: h * 0.17) {
                    guard !celebrate else { return }
                    game.completeGame()
                    celebrate = true
                }
                .position(x: w * 0.5, y: h * 0.17)

                wardrobe(height: h * 0.86)
                    .position(x: w * 0.78, y: h * 0.52)

                VStack {
                    HStack {
                        HomeButton { game.go(.menu) }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)

                if celebrate {
                    CelebrationView(title: "Sluší ti to!") { game.go(.menu) }
                }
            }
        }
        .ignoresSafeArea()
    }

    private func wardrobe(height: CGFloat) -> some View {
        let tab = height * 0.15
        let cell = height * 0.29
        return HStack(spacing: -6) {
            // Záložky s kategoriemi
            VStack(spacing: tab * 0.12) {
                ForEach(WardrobeCategory.allCases) { c in
                    Button {
                        Haptics.tap()
                        category = c
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(c == category ? Color(hex: 0x8EDB4E) : Color(hex: 0xF27DB8))
                            RoundedRectangle(cornerRadius: 11)
                                .strokeBorder(Color.white, style: StrokeStyle(lineWidth: 3, dash: [5, 4]))
                                .padding(3)
                            RegionThumb(region: c.region, size: tab * 0.78) { c.items[0].view }
                        }
                        .frame(width: tab, height: tab)
                    }
                    .buttonStyle(BouncyButtonStyle())
                }
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 22).fill(Color(hex: 0x4FA8F0)))

            // Mřížka s věcmi
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.fixed(cell), spacing: 14), GridItem(.fixed(cell))], spacing: 14) {
                    ForEach(category.items) { item in
                        let worn = item.isWorn(game.outfit)
                        Button {
                            Haptics.pop()
                            var o = game.outfit
                            item.toggle(&o)
                            game.outfit = o
                            bounce += 1
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(worn ? Color(hex: 0x8EDB4E) : Color(hex: 0x9AD6FF))
                                    .shadow(color: worn ? Color(hex: 0x5AAE2A) : Color(hex: 0x5AAEF0), radius: 0, y: 5)
                                RegionThumb(region: category.region, size: cell * 0.84) { item.view }
                            }
                            .frame(width: cell, height: cell)
                        }
                        .buttonStyle(BouncyButtonStyle())
                    }
                }
                .padding(16)
            }
            .frame(width: cell * 2 + 46)
            .background(
                RoundedRectangle(cornerRadius: 34).fill(Color(hex: 0xE3F4FF))
            )
            .overlay(RoundedRectangle(cornerRadius: 34).strokeBorder(Color(hex: 0x4FA8F0), lineWidth: 12))
            .overlay(RoundedRectangle(cornerRadius: 34).inset(by: -4).strokeBorder(Color.white, lineWidth: 4))
            .clipShape(RoundedRectangle(cornerRadius: 34).inset(by: -8))
        }
        .frame(height: height)
    }
}
