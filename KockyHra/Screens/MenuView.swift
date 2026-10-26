import SwiftUI

/// Výběr miniher – kartičky s modrým tlačítkem „hrát“.
struct MenuView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        GeometryReader { g in
            let h = g.size.height
            let cardH = h * 0.58
            let cardW = cardH * 1.45
            ZStack {
                VStack(spacing: 0) {
                    TileWall(color: Color(hex: 0xA8D4FF), line: Color(hex: 0x93C6F8), tile: 90, diagonal: true)
                        .frame(height: h * 0.42)
                    Color(hex: 0x7FB6F0).frame(height: h * 0.03)
                    ZStack {
                        LinearGradient(colors: [Color(hex: 0xE6B9A8), Color(hex: 0xD49B8A)], startPoint: .top, endPoint: .bottom)
                        FloorBoards(color: Color(hex: 0xC4877A).opacity(0.5))
                    }
                }

                VStack {
                    HintBubble(text: "Co budeme dělat? Vyber si hru!")
                        .padding(.top, 18)
                    Spacer()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: cardW * 0.12) {
                        GameCard(title: "Šatník", width: cardW, height: cardH, colors: [0xFFD6E8, 0xF7B6D2]) {
                            dressUpPreview
                        } action: { game.go(.dressUp) }
                        GameCard(title: "Krmení", width: cardW, height: cardH, colors: [0xFFE3C2, 0xF7C79A]) {
                            feedingPreview
                        } action: { game.go(.feeding) }
                        GameCard(title: "Záchodek", width: cardW, height: cardH, colors: [0xE9DBFF, 0xD3BDF7]) {
                            litterPreview
                        } action: { game.go(.litter) }
                        GameCard(title: "Koupání", width: cardW, height: cardH, colors: [0xD3F0FF, 0xA8DCF7]) {
                            groomingPreview
                        } action: { game.go(.grooming) }
                    }
                    .padding(.horizontal, cardW * 0.25)
                    .padding(.top, h * 0.2)
                    .padding(.bottom, h * 0.18)
                }

                TopBar(stars: game.stars) { game.go(.select) }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: Náhledy na kartičkách

    private var previewOutfit: Outfit {
        let o = game.outfit
        return o == Outfit() ? Outfit(hat: .crown, glasses: .heartPink, shirt: .dress) : o
    }

    private var dressUpPreview: some View {
        GeometryReader { g in
            ZStack {
                Rug().frame(width: g.size.width * 0.6, height: g.size.height * 0.3)
                    .position(x: g.size.width * 0.5, y: g.size.height * 0.9)
                BoardView(height: g.size.height * 0.95) {
                    CatView(cat: game.cat, outfit: previewOutfit, eyes: .happy)
                }
                .position(x: g.size.width * 0.5, y: g.size.height * 0.55)
            }
        }
    }

    private var feedingPreview: some View {
        GeometryReader { g in
            let h = g.size.height
            ZStack {
                BoardView(height: h * 0.95) {
                    ZStack {
                        ArmchairDrawing()
                        CatView(cat: game.cat, mouthOpen: true, blinks: false)
                    }
                }
                .position(x: g.size.width * 0.38, y: h * 0.56)
                ThoughtBubble(size: h * 0.4) {
                    IconBoard(size: h * 0.3) { Food.fish.drawing }
                }
                .position(x: g.size.width * 0.75, y: h * 0.3)
            }
        }
    }

    private var litterPreview: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                BoardView(height: h * 0.8) {
                    CatView(cat: game.cat, eyes: .happy, blinks: false)
                }
                .position(x: w * 0.25, y: h * 0.58)
                LitterBoxView().frame(width: w * 0.45, height: h * 0.34)
                    .position(x: w * 0.68, y: h * 0.76)
                IconBoard(size: h * 0.16) { PoopDrawing() }.position(x: w * 0.62, y: h * 0.72)
                IconBoard(size: h * 0.13) { PoopDrawing() }.position(x: w * 0.76, y: h * 0.78)
                IconBoard(size: h * 0.36) { ScoopDrawing() }
                    .rotationEffect(.degrees(-15))
                    .position(x: w * 0.78, y: h * 0.36)
            }
        }
    }

    private var groomingPreview: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                BoardView(height: h * 0.95) {
                    ZStack {
                        CatView(cat: game.cat, mouthOpen: true, blinks: false)
                        IconBoard(size: 80) { DirtDrawing(kind: .bubbles) }.position(x: 90, y: 90)
                        IconBoard(size: 70) { DirtDrawing(kind: .bubbles) }.position(x: 210, y: 300)
                        IconBoard(size: 60) { DirtDrawing(kind: .leaf) }.position(x: 220, y: 80)
                    }
                }
                .position(x: w * 0.42, y: h * 0.55)
                IconBoard(size: h * 0.34) { GroomTool.comb.drawing }
                    .rotationEffect(.degrees(25))
                    .position(x: w * 0.82, y: h * 0.4)
            }
        }
    }
}

struct GameCard<Preview: View>: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let colors: [UInt32]
    @ViewBuilder var preview: Preview
    let action: () -> Void

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: height * 0.24, style: .continuous)
        ZStack(alignment: .top) {
            ZStack {
                shape.fill(LinearGradient(colors: colors.map { Color(hex: $0) }, startPoint: .top, endPoint: .bottom))
                preview
                    .padding(.top, height * 0.08)
                    .padding(.bottom, height * 0.1)
            }
            .clipShape(shape)
            .overlay(shape.strokeBorder(Color(hex: 0xF04FAE), lineWidth: 10))
            .overlay(shape.inset(by: -5).strokeBorder(Color.white, lineWidth: 5))
            .shadow(color: .black.opacity(0.2), radius: 4, y: 6)

            Text(title)
                .font(.system(size: height * 0.11, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color(hex: 0xF04FAE)))
                .overlay(Capsule().strokeBorder(Color.white, lineWidth: 4))
                .offset(y: -height * 0.1)

            PlayButton(size: height * 0.34, action: action)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: height * 0.17)
        }
        .frame(width: width, height: height)
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}
