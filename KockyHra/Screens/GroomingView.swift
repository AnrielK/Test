import SwiftUI

/// Koupání a česání: hřebenem pryč lístky, houbičkou bláto (udělá pěnu) a sprchou pěnu.
struct GroomingView: View {
    @Environment(GameState.self) private var game

    private struct Dirt: Identifiable {
        let id: Int
        var kind: DirtKind
        /// Poloha v plátně kočičky (300 × 400).
        let x: CGFloat
        let y: CGFloat
        let angle: Double
    }

    private static let startDirt: [Dirt] = [
        Dirt(id: 0, kind: .leaf, x: 74, y: 92, angle: -20),
        Dirt(id: 1, kind: .leaf, x: 230, y: 104, angle: 30),
        Dirt(id: 2, kind: .leaf, x: 116, y: 294, angle: 10),
        Dirt(id: 3, kind: .leaf, x: 206, y: 326, angle: -35),
        Dirt(id: 4, kind: .mud, x: 238, y: 184, angle: 0),
        Dirt(id: 5, kind: .mud, x: 60, y: 206, angle: 40),
        Dirt(id: 6, kind: .mud, x: 164, y: 300, angle: 90),
        Dirt(id: 7, kind: .mud, x: 98, y: 348, angle: 0),
        Dirt(id: 8, kind: .mud, x: 198, y: 262, angle: 200),
    ]

    @State private var dirt = GroomingView.startDirt
    @State private var tool: GroomTool = .comb
    @State private var finger: CGPoint?
    @State private var sparkle = 0
    @State private var done = false
    @State private var celebrate = false

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            let catH = h * 0.86
            let scale = catH / Board.height
            let center = CGPoint(x: w * 0.4, y: h * 0.55)
            let origin = CGPoint(x: center.x - Board.width / 2 * scale, y: center.y - Board.height / 2 * scale)
            let toolSize = h * 0.2
            ZStack {
                RoomBackground(wallA: Color(hex: 0xFFE3EF), wallB: Color(hex: 0xFFC9DF), trim: Color(hex: 0xF29CC4),
                               floor: Color(hex: 0xBFE3F7), floorDark: Color(hex: 0x9ACDEB), horizon: 0.6,
                               curtains: nil, tiled: true)

                Rug(color: Color(hex: 0x6CC0FF), inner: Color(hex: 0x4FA8F0), lace: Color.white)
                    .frame(width: w * 0.34, height: h * 0.22)
                    .position(x: center.x, y: h * 0.9)

                BoardView(height: catH) {
                    ZStack {
                        CatView(cat: game.cat, eyes: done ? .happy : .open, mouthOpen: done)
                        ForEach(dirt) { d in
                            IconBoard(size: d.kind == .bubbles ? 78 : 64) { DirtDrawing(kind: d.kind) }
                                .rotationEffect(.degrees(d.kind == .bubbles ? 0 : d.angle))
                                .position(x: d.x, y: d.y)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .position(center)

                SparkleBurst(trigger: sparkle)
                    .position(center)

                // Plocha, po které se jezdí nástrojem
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("bath"))
                            .onChanged { v in
                                finger = v.location
                                clean(at: CGPoint(x: (v.location.x - origin.x) / scale,
                                                  y: (v.location.y - origin.y) / scale))
                            }
                            .onEnded { _ in finger = nil }
                    )

                if let finger {
                    IconBoard(size: toolSize) { tool.drawing }
                        .rotationEffect(.degrees(tool == .comb ? -15 : 0))
                        .position(x: finger.x, y: finger.y - toolSize * 0.25)
                        .allowsHitTesting(false)
                }

                // Nástroje
                VStack(spacing: h * 0.04) {
                    ForEach(GroomTool.allCases) { t in
                        Button {
                            Haptics.tap()
                            tool = t
                        } label: {
                            ZStack {
                                Circle().fill(t == tool ? Color(hex: 0x8EDB4E) : Color.white)
                                Circle().strokeBorder(t == tool ? Color(hex: 0x4CA82A) : Color(hex: 0x9AD6FF), lineWidth: 5)
                                IconBoard(size: toolSize * 0.75) { t.drawing }
                            }
                            .frame(width: toolSize, height: toolSize)
                            .scaleEffect(t == tool ? 1.08 : 1)
                            .shadow(color: .black.opacity(0.2), radius: 3, y: 4)
                        }
                        .buttonStyle(BouncyButtonStyle())
                    }
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(hex: 0x4FA8F0).opacity(0.9)))
                .position(x: w * 0.85, y: h * 0.55)

                VStack {
                    HStack {
                        HomeButton { game.go(.menu) }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)

                VStack {
                    HintBubble(text: hint)
                        .padding(.top, 20)
                    Spacer()
                }
                .allowsHitTesting(false)

                if celebrate {
                    CelebrationView(title: "Voňavá kočička!") { game.go(.menu) }
                }
            }
            .coordinateSpace(.named("bath"))
        }
        .ignoresSafeArea()
    }

    private var hint: String {
        if done { return "Hotovo, kočička je čisťoučká!" }
        if dirt.contains(where: { $0.kind == .leaf }) { return GroomTool.comb.hint }
        if dirt.contains(where: { $0.kind == .mud }) { return GroomTool.sponge.hint }
        return GroomTool.shower.hint
    }

    /// `point` je v souřadnicích plátna kočičky.
    private func clean(at point: CGPoint) {
        guard !done else { return }
        var changed = false
        for d in dirt where hypot(d.x - point.x, d.y - point.y) < 44 {
            switch (tool, d.kind) {
            case (.comb, .leaf), (.shower, .bubbles):
                withAnimation(.spring(response: 0.3)) { dirt.removeAll { $0.id == d.id } }
                changed = true
            case (.sponge, .mud):
                if let i = dirt.firstIndex(where: { $0.id == d.id }) {
                    withAnimation(.spring(response: 0.3)) { dirt[i].kind = .bubbles }
                    changed = true
                }
            default:
                break
            }
        }
        guard changed else { return }
        Haptics.tap()
        if dirt.isEmpty {
            done = true
            sparkle += 1
            game.completeGame()
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1))
                celebrate = true
            }
        }
    }
}
