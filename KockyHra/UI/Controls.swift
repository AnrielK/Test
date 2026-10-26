import SwiftUI

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

/// Lesklé kulaté tlačítko jako v dětských hrách.
struct GlossyCircle: View {
    let top: Color
    let bottom: Color
    var ring: Color = .white
    var ringWidth: CGFloat = 5

    var body: some View {
        ZStack {
            Circle().fill(LinearGradient(colors: [top, bottom], startPoint: .top, endPoint: .bottom))
            Circle().strokeBorder(ring, lineWidth: ringWidth)
            GeometryReader { g in
                Ellipse()
                    .fill(Color.white.opacity(0.45))
                    .frame(width: g.size.width * 0.28, height: g.size.height * 0.16)
                    .rotationEffect(.degrees(-35))
                    .position(x: g.size.width * 0.3, y: g.size.height * 0.24)
            }
        }
        .shadow(color: .black.opacity(0.25), radius: 3, y: 4)
    }
}

struct HomeButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.tap()
            action()
        } label: {
            ZStack {
                GlossyCircle(top: Color(hex: 0x6CC0FF), bottom: Color(hex: 0x1E78E8))
                Image(systemName: "house.fill")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 62, height: 62)
        }
        .buttonStyle(BouncyButtonStyle())
    }
}

struct PlayButton: View {
    var size: CGFloat = 90
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.tap()
            action()
        } label: {
            ZStack {
                GlossyCircle(top: Color(hex: 0x5FB2FF), bottom: Color(hex: 0x1E6FE0), ringWidth: size * 0.08)
                Image(systemName: "play.fill")
                    .font(.system(size: size * 0.4, weight: .black))
                    .foregroundStyle(.white)
                    .offset(x: size * 0.04)
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(BouncyButtonStyle())
    }
}

/// Zelené „hotovo“ visící na růžovém provázku.
struct HangingCheckButton: View {
    var size: CGFloat = 86
    var rope: CGFloat = 70
    let action: () -> Void
    @State private var swing = false

    var body: some View {
        VStack(spacing: -4) {
            Capsule().fill(Color(hex: 0xE0509C)).frame(width: 9, height: rope)
            Button {
                Haptics.pop()
                action()
            } label: {
                ZStack {
                    Circle().fill(Color(hex: 0xF070B4)).frame(width: size + 14, height: size + 14)
                    GlossyCircle(top: Color(hex: 0x9CF06A), bottom: Color(hex: 0x3CC23C), ringWidth: 4)
                        .frame(width: size, height: size)
                    Image(systemName: "checkmark")
                        .font(.system(size: size * 0.42, weight: .black))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(BouncyButtonStyle())
        }
        .rotationEffect(.degrees(swing ? 4 : -4), anchor: .top)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { swing = true }
        }
    }
}

struct StarCounter: View {
    let stars: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .foregroundStyle(Color(hex: 0xFFC21F))
                .shadow(color: Color(hex: 0xC98A10), radius: 0, y: 2)
            Text("\(stars)")
                .foregroundStyle(Color(hex: 0x6A3A9E))
        }
        .font(.system(size: 26, weight: .heavy, design: .rounded))
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.white).shadow(color: .black.opacity(0.2), radius: 2, y: 3))
    }
}

/// Bublina s textem nebo nápovědou.
struct HintBubble: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 22, weight: .heavy, design: .rounded))
            .foregroundStyle(Color(hex: 0x6A3A9E))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.white.opacity(0.92)).shadow(color: .black.opacity(0.15), radius: 2, y: 3))
    }
}

/// Domeček vlevo nahoře a hvězdičky vpravo.
struct TopBar: View {
    let stars: Int
    let onHome: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                HomeButton(action: onHome)
                Spacer()
                StarCounter(stars: stars)
            }
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.top, 16)
    }
}

// MARK: - Oslava

struct CelebrationView: View {
    var title = "Výborně!"
    let onDone: () -> Void
    @State private var appear = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()
            ConfettiView()
            VStack(spacing: 14) {
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: i == 1 ? 70 : 52))
                            .foregroundStyle(LinearGradient(colors: [Color(hex: 0xFFF08A), Color(hex: 0xFFB21F)], startPoint: .top, endPoint: .bottom))
                            .shadow(color: Color(hex: 0xC98A10), radius: 0, y: 4)
                            .offset(y: i == 1 ? -14 : 0)
                    }
                }
                Text(title)
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: Color(hex: 0xD9408F), radius: 0, x: 0, y: 5)
                PlayButton(size: 84, action: onDone)
            }
            .scaleEffect(appear ? 1 : 0.2)
            .opacity(appear ? 1 : 0)
        }
        .onAppear {
            Haptics.success()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) { appear = true }
        }
    }
}

struct ConfettiView: View {
    private struct Piece {
        let x: Double, y0: Double, speed: Double, wobble: Double, phase: Double, spin: Double
        let color: Color
        let size: CGSize
    }

    @State private var start = Date()
    @State private var pieces: [Piece] = (0..<80).map { _ in
        Piece(x: .random(in: 0...1), y0: .random(in: -1...0), speed: .random(in: 0.18...0.38),
              wobble: .random(in: 1...3), phase: .random(in: 0...6), spin: .random(in: -6...6),
              color: [Color(hex: 0xFF5FA2), Color(hex: 0xFFD23F), Color(hex: 0x3FD0C9), Color(hex: 0x7B5CFF), Color(hex: 0x5FD35F)].randomElement()!,
              size: CGSize(width: .random(in: 8...14), height: .random(in: 6...10)))
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSince(start)
                for p in pieces {
                    let y = (p.y0 + t * p.speed).truncatingRemainder(dividingBy: 1.2) - 0.05
                    let x = p.x + sin(t * p.wobble + p.phase) * 0.03
                    var c = ctx
                    c.translateBy(x: x * size.width, y: y * size.height)
                    c.rotate(by: .radians(t * p.spin))
                    let r = CGRect(x: -p.size.width / 2, y: -p.size.height / 2, width: p.size.width, height: p.size.height)
                    c.fill(Path(roundedRect: r, cornerRadius: 2), with: .color(p.color))
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

/// Třpytky a srdíčka, která vybuchnou kolem kočičky pokaždé, když se změní `trigger`.
struct SparkleBurst: View {
    let trigger: Int

    var body: some View {
        ZStack {
            if trigger > 0 {
                Burst().id(trigger)
            }
        }
        .allowsHitTesting(false)
    }

    private struct Burst: View {
        @State private var animate = false

        var body: some View {
            ZStack {
                ForEach(0..<10, id: \.self) { i in
                    let a = CGFloat(i) / 10 * 2 * .pi
                    Image(systemName: i.isMultiple(of: 2) ? "sparkle" : "heart.fill")
                        .font(.system(size: i.isMultiple(of: 2) ? 30 : 22))
                        .foregroundStyle(i.isMultiple(of: 2) ? Color(hex: 0xFFD23F) : Color(hex: 0xFF5FA2))
                        .offset(x: animate ? cos(a) * 130 : 0, y: animate ? sin(a) * 130 : 0)
                        .opacity(animate ? 0 : 1)
                        .scaleEffect(animate ? 1.3 : 0.3)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.9)) { animate = true }
            }
        }
    }
}
