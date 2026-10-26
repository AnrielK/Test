import SwiftUI

/// Jeviště se třemi spícími koťátky. Ťuknutím se koťátko probudí a jde se hrát.
struct SelectCatView: View {
    @Environment(GameState.self) private var game
    @State private var awake: Int?
    @State private var hop = false

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                VStack(spacing: 0) {
                    TileWall(color: Color(hex: 0xA8D4FF), line: Color(hex: 0x93C6F8), tile: 90, diagonal: true)
                        .frame(height: h * 0.5)
                    Color(hex: 0x7FB6F0).frame(height: h * 0.03)
                    LinearGradient(colors: [Color(hex: 0xE6B9A8), Color(hex: 0xD49B8A)], startPoint: .top, endPoint: .bottom)
                }
                StageCurtains()

                ForEach(Array(Cat.all.enumerated()), id: \.element.id) { index, cat in
                    let x = w * (0.24 + 0.26 * CGFloat(index))
                    let big = index == 1
                    let catH = h * (big ? 0.66 : 0.58)
                    let baseY = h * (big ? 0.8 : 0.74)
                    let isAwake = awake == cat.id

                    Pedestal()
                        .frame(width: w * (big ? 0.27 : 0.23), height: h * 0.2)
                        .position(x: x, y: baseY)

                    BoardView(height: catH) {
                        CatView(cat: cat, eyes: isAwake ? .happy : .closed, mouthOpen: isAwake, blinks: false)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { pick(cat) }
                    .scaleEffect(isAwake && hop ? 1.08 : 1, anchor: .bottom)
                    .offset(y: isAwake && hop ? -h * 0.06 : 0)
                    .position(x: x, y: baseY - catH * 0.44)

                    Text(cat.name)
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color(hex: 0xD9408F)))
                        .position(x: x, y: baseY + h * 0.11)
                }

                VStack {
                    HStack {
                        Spacer()
                        HintBubble(text: awake == nil ? "Ťukni na koťátko a probuď ho!" : "Mňau! Jdeme si hrát!")
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 18)

                VStack {
                    HStack {
                        Spacer()
                        StarCounter(stars: game.stars)
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
            }
        }
        .ignoresSafeArea()
    }

    private func pick(_ cat: Cat) {
        guard awake == nil else { return }
        Haptics.pop()
        game.choose(cat)
        awake = cat.id
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4).repeatCount(3, autoreverses: true)) {
            hop = true
        }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.3))
            game.go(.menu)
        }
    }
}
