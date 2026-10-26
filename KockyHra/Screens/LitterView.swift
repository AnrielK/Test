import SwiftUI

/// Záchodek: lopatkou se vyberou hrudky z písku a vysypou do koše.
struct LitterView: View {
    @Environment(GameState.self) private var game

    private struct Clump: Identifiable {
        let id: Int
        /// Poloha v bedýnce (0…1).
        let u: CGFloat
        let v: CGFloat
        var collected = false
    }

    private struct Layout {
        let size: CGSize
        var box: CGRect { CGRect(x: size.width * 0.3, y: size.height * 0.57, width: size.width * 0.4, height: size.height * 0.34) }
        var bin: CGPoint { CGPoint(x: size.width * 0.87, y: size.height * 0.76) }
        var binSize: CGFloat { size.height * 0.28 }
        var scoopSize: CGFloat { size.height * 0.3 }
        var scoopStart: CGPoint { CGPoint(x: size.width * 0.84, y: size.height * 0.36) }
        var cat: CGPoint { CGPoint(x: size.width * 0.15, y: size.height * 0.58) }
        var clumpSize: CGFloat { size.height * 0.1 }

        func point(_ c: Clump) -> CGPoint { CGPoint(x: box.minX + box.width * c.u, y: box.minY + box.height * c.v) }
        /// Lopatka sbírá svou hlavou, ne místem, kde je prst.
        func head(_ scoop: CGPoint) -> CGPoint { CGPoint(x: scoop.x - scoopSize * 0.16, y: scoop.y + scoopSize * 0.13) }
    }

    private let capacity = 3

    @State private var clumps: [Clump] = []
    @State private var scoop: CGPoint?
    @State private var carried = 0
    @State private var binBounce = 0
    @State private var sparkle = 0
    @State private var done = false
    @State private var celebrate = false

    var body: some View {
        GeometryReader { g in
            let L = Layout(size: g.size)
            let scoopPos = scoop ?? L.scoopStart
            ZStack {
                RoomBackground(wallA: Color(hex: 0xE2F3FF), wallB: Color(hex: 0xC4E4FA), trim: Color(hex: 0x8EC5F0),
                               floor: Color(hex: 0xD9C9F2), floorDark: Color(hex: 0xBBA4E2), horizon: 0.56,
                               curtains: nil, tiled: true)

                Rug(color: Color(hex: 0xFF9BCB), inner: Color(hex: 0xFF7BB8))
                    .frame(width: g.size.width * 0.26, height: g.size.height * 0.2)
                    .position(x: L.cat.x, y: g.size.height * 0.88)

                BoardView(height: g.size.height * 0.62) {
                    CatView(cat: game.cat, outfit: game.outfit, eyes: done ? .happy : .open, mouthOpen: !done)
                }
                .position(L.cat)

                SparkleBurst(trigger: sparkle)
                    .position(x: L.box.midX, y: L.box.midY)

                LitterBoxView()
                    .frame(width: L.box.width, height: L.box.height)
                    .position(x: L.box.midX, y: L.box.midY)

                ForEach(clumps.filter { !$0.collected }) { c in
                    IconBoard(size: L.clumpSize) { PoopDrawing() }
                        .position(L.point(c))
                        .transition(.scale)
                }

                IconBoard(size: L.binSize) { BinDrawing() }
                    .phaseAnimator([1.0, 1.15], trigger: binBounce) { view, s in
                        view.scaleEffect(s, anchor: .bottom)
                    }
                    .position(L.bin)

                IconBoard(size: L.scoopSize) { ScoopDrawing(carried: carried) }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("litter"))
                            .onChanged { v in moveScoop(to: v.location, layout: L) }
                    )
                    .position(scoopPos)

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
                    HintBubble(text: done ? "Hurá, je čisto!" : "Lopatkou vyber hrudky a vysyp je do koše")
                        .padding(.top, 20)
                    Spacer()
                }

                if celebrate {
                    CelebrationView(title: "Krásně uklizeno!") { game.go(.menu) }
                }
            }
            .coordinateSpace(.named("litter"))
        }
        .ignoresSafeArea()
        .onAppear(perform: scatter)
    }

    private func scatter() {
        var result: [Clump] = []
        var tries = 0
        while result.count < 6 && tries < 500 {
            tries += 1
            let u = CGFloat.random(in: 0.16...0.84)
            let v = CGFloat.random(in: 0.28...0.72)
            if result.allSatisfy({ hypot($0.u - u, ($0.v - v) * 0.5) > 0.13 }) {
                result.append(Clump(id: result.count, u: u, v: v))
            }
        }
        clumps = result
    }

    private func moveScoop(to point: CGPoint, layout L: Layout) {
        guard !done else { return }
        scoop = point
        let head = L.head(point)

        for i in clumps.indices where !clumps[i].collected && carried < capacity {
            let c = L.point(clumps[i])
            if hypot(c.x - head.x, c.y - head.y) < L.clumpSize * 0.8 {
                Haptics.tap()
                withAnimation(.spring(response: 0.3)) { clumps[i].collected = true }
                carried += 1
            }
        }

        if carried > 0 && hypot(head.x - L.bin.x, head.y - L.bin.y) < L.binSize * 0.6 {
            Haptics.pop()
            carried = 0
            binBounce += 1
            if clumps.allSatisfy(\.collected) {
                finish()
            }
        }
    }

    private func finish() {
        done = true
        sparkle += 1
        game.completeGame()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            celebrate = true
        }
    }
}
