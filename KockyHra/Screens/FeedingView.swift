import SwiftUI

/// Krmení: kočička si v bublině řekne, na co má chuť, a dítě jí to přinese z lednice.
struct FeedingView: View {
    @Environment(GameState.self) private var game

    private let goal = 5

    @State private var wanted: Food = Food.allCases.randomElement()!
    @State private var fed = 0
    @State private var eating: Food?
    @State private var chewing = false
    @State private var yuck = false
    @State private var yuckCount = 0
    @State private var hearts = 0
    @State private var dragFood: Food?
    @State private var dragPoint: CGPoint = .zero
    @State private var celebrate = false

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            let cat = CGPoint(x: w * 0.3, y: h * 0.56)
            let foodSize = h * 0.17
            ZStack {
                RoomBackground(wallA: Color(hex: 0xFFD9EA), wallB: Color(hex: 0xFFC9E0), trim: Color(hex: 0xE57BB0),
                               floor: Color(hex: 0xE3AE96), floorDark: Color(hex: 0xC98C72), horizon: 0.6, curtains: nil)

                BoardView(height: h * 0.78) {
                    ZStack {
                        ArmchairDrawing()
                        CatView(cat: game.cat, outfit: game.outfit,
                                eyes: eating != nil ? .happy : .open,
                                mouthOpen: chewing || yuck)
                    }
                }
                .phaseAnimator([0.0, -7, 7, -5, 5, 0], trigger: yuckCount) { view, angle in
                    view.rotationEffect(.degrees(angle), anchor: .bottom)
                } animation: { _ in .easeInOut(duration: 0.09) }
                .position(cat)

                SparkleBurst(trigger: hearts)
                    .position(x: cat.x, y: cat.y - h * 0.1)

                // Talířek
                ZStack {
                    Ellipse().fill(Color(hex: 0x6CC0FF))
                    Ellipse().fill(Color.white).padding(6)
                    Ellipse().fill(Color(hex: 0xEAF6FF)).padding(18)
                    if let eating {
                        IconBoard(size: foodSize) { eating.drawing }
                            .scaleEffect(chewing ? 0.8 : 1)
                            .offset(y: -foodSize * 0.2)
                    }
                }
                .frame(width: w * 0.2, height: h * 0.1)
                .position(x: cat.x, y: h * 0.91)

                // Na co má kočička chuť
                ThoughtBubble(size: h * 0.32) {
                    IconBoard(size: h * 0.22) { wanted.drawing }
                        .id(wanted)
                        .transition(.scale.combined(with: .opacity))
                }
                .position(x: w * 0.52, y: h * 0.2)

                if yuck {
                    HintBubble(text: "Fuj, to nechci!")
                        .position(x: w * 0.12, y: h * 0.3)
                        .transition(.scale)
                }

                fridge(w: w, h: h, foodSize: foodSize, target: cat)

                // Kolik už snědla
                HStack(spacing: 8) {
                    ForEach(0..<goal, id: \.self) { i in
                        Image(systemName: "heart.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(i < fed ? Color(hex: 0xFF4F8E) : Color.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.15), radius: 1, y: 2)
                    }
                }
                .position(x: w * 0.8, y: h * 0.08)

                if let dragFood {
                    IconBoard(size: foodSize * 1.2) { dragFood.drawing }
                        .position(dragPoint)
                        .allowsHitTesting(false)
                }

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
                    CelebrationView(title: "Mňam, mňam!") { game.go(.menu) }
                }
            }
            .coordinateSpace(.named("kitchen"))
        }
        .ignoresSafeArea()
    }

    private func fridge(w: CGFloat, h: CGFloat, foodSize: CGFloat, target: CGPoint) -> some View {
        let frame = CGRect(x: w * 0.64, y: h * 0.16, width: w * 0.32, height: h * 0.8)
        let foods = Food.allCases
        return ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(hex: 0x6CC0FF))
                .frame(width: frame.width, height: frame.height)
                .position(x: frame.midX, y: frame.midY)
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(colors: [Color(hex: 0xE8F7FF), Color(hex: 0xC6E9FF)], startPoint: .top, endPoint: .bottom))
                .frame(width: frame.width - 24, height: frame.height - 24)
                .position(x: frame.midX, y: frame.midY)
            ForEach(1..<3, id: \.self) { row in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: 0x8ED0FF))
                    .frame(width: frame.width - 24, height: 8)
                    .position(x: frame.midX, y: frame.minY + frame.height * CGFloat(row) / 3)
            }
            ForEach(Array(foods.enumerated()), id: \.element) { index, food in
                let col = CGFloat(index % 2), row = CGFloat(index / 2)
                let slot = CGPoint(x: frame.minX + frame.width * (0.28 + 0.44 * col),
                                   y: frame.minY + frame.height * (0.19 + row / 3))
                IconBoard(size: foodSize) { food.drawing }
                    .opacity(dragFood == food ? 0.35 : 1)
                    .contentShape(Rectangle())
                    .onTapGesture { give(food) }
                    .gesture(
                        DragGesture(minimumDistance: 4, coordinateSpace: .named("kitchen"))
                            .onChanged { v in
                                dragFood = food
                                dragPoint = v.location
                            }
                            .onEnded { v in
                                dragFood = nil
                                if hypot(v.location.x - target.x, v.location.y - target.y) < h * 0.4 {
                                    give(food)
                                }
                            }
                    )
                    .position(slot)
            }
        }
    }

    private func give(_ food: Food) {
        guard eating == nil, !celebrate else { return }
        if food == wanted {
            Haptics.success()
            eating = food
            hearts += 1
            Task { @MainActor in
                for _ in 0..<6 {
                    chewing.toggle()
                    try? await Task.sleep(for: .milliseconds(180))
                }
                chewing = false
                fed += 1
                withAnimation(.spring) {
                    eating = nil
                    wanted = Food.allCases.filter { $0 != wanted }.randomElement()!
                }
                if fed >= goal {
                    game.completeGame()
                    celebrate = true
                }
            }
        } else {
            Haptics.nope()
            yuckCount += 1
            withAnimation(.spring) { yuck = true }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1))
                withAnimation { yuck = false }
            }
        }
    }
}
