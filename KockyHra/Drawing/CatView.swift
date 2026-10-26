import SwiftUI

enum EyeState {
    case open
    /// Spí – očička dolů.
    case closed
    /// Směje se – očička obloučkem nahoru.
    case happy
}

/// Kočička v plátně 300 × 400 i s oblečením. Velikost se nastavuje přes `BoardView`.
struct CatView: View {
    let cat: Cat
    var outfit = Outfit()
    var eyes: EyeState = .open
    var mouthOpen = false
    var blinks = true

    @State private var blinking = false

    var body: some View {
        ZStack {
            CatBodyLayer(cat: cat)
            if let pants = outfit.pants { pants.view }
            if let shoes = outfit.shoes { shoes.view }
            CatArmsLayer(cat: cat)
            if let shirt = outfit.shirt { shirt.view }
            CatHeadLayer(cat: cat, eyes: (eyes == .open && blinking) ? .closed : eyes, mouthOpen: mouthOpen)
            if let glasses = outfit.glasses { glasses.view }
            if let hat = outfit.hat { hat.view }
        }
        .frame(width: Board.width, height: Board.height)
        .task {
            guard blinks else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Double.random(in: 2.5...5)))
                blinking = true
                try? await Task.sleep(for: .milliseconds(140))
                blinking = false
            }
        }
    }
}

struct CatBodyLayer: View {
    let cat: Cat

    var body: some View {
        ZStack {
            Limb(path: tail, color: cat.bodyFur, outline: cat.dark, width: 20)
            Blob(oval(255, 246, 26, 26), cat.paw, line: cat.dark)

            Limb(path: polyline(P(127, 338), P(126, 372)), color: cat.bodyFur, outline: cat.dark, width: 30)
            Limb(path: polyline(P(173, 338), P(174, 372)), color: cat.bodyFur, outline: cat.dark, width: 30)

            Blob(oval(150, 300, 124, 136), cat.bodyFur, line: cat.dark, width: 3.5)
            Blob(oval(150, 314, 72, 86), cat.belly)
            Line(polyline(P(150, 338), P(150, 352)), cat.dark.opacity(0.35), 3)

            foot(124)
            foot(176)
        }
    }

    private var tail: Path {
        var p = Path()
        p.move(to: P(188, 348))
        p.addCurve(to: P(252, 250), control1: P(262, 362), control2: P(280, 290))
        return p
    }

    private func foot(_ cx: CGFloat) -> some View {
        ZStack {
            Blob(oval(cx, 380, 46, 26), cat.paw, line: cat.dark)
            Line(polyline(P(cx - 8, 372), P(cx - 8, 380)), cat.dark.opacity(0.5), 2.5)
            Line(polyline(P(cx + 8, 372), P(cx + 8, 380)), cat.dark.opacity(0.5), 2.5)
        }
    }
}

struct CatArmsLayer: View {
    let cat: Cat

    var body: some View {
        ZStack {
            Limb(path: polyline(P(104, 262), P(74, 300)), color: cat.bodyFur, outline: cat.dark, width: 28)
            Limb(path: polyline(P(196, 262), P(226, 300)), color: cat.bodyFur, outline: cat.dark, width: 28)
            paw(70)
            paw(230)
        }
    }

    private func paw(_ cx: CGFloat) -> some View {
        ZStack {
            Blob(oval(cx, 306, 36, 30), cat.paw, line: cat.dark)
            Blob(oval(cx, 310, 12, 9), Color(hex: 0xFFA3BC))
            Blob(oval(cx - 9, 300, 6, 6), Color(hex: 0xFFA3BC))
            Blob(oval(cx, 297, 6, 6), Color(hex: 0xFFA3BC))
            Blob(oval(cx + 9, 300, 6, 6), Color(hex: 0xFFA3BC))
        }
    }
}

struct CatHeadLayer: View {
    let cat: Cat
    let eyes: EyeState
    let mouthOpen: Bool

    private let ink = Color(hex: 0x1A1A24)
    private let earPink = Color(hex: 0xF7B3C2)

    var body: some View {
        ZStack {
            // Obojek se zvonečkem
            Blob(roundRect(96, 238, 108, 14, 7), Color(hex: 0x2B2B3A))
            Blob(oval(150, 259, 26, 26), radial([.white, cat.bell], 145, 253, 16), line: .black.opacity(0.35), width: 2)
            Line(polyline(P(150, 262), P(150, 270)), .black.opacity(0.45), 3)

            // Ouška
            Blob(poly([P(40, 128), P(60, 18), P(142, 62)]), cat.pattern == .patches ? cat.patch : cat.fur,
                 line: cat.dark, width: 4)
            Blob(poly([P(58, 108), P(68, 44), P(118, 70)]), earPink)
            Blob(poly([P(260, 128), P(240, 18), P(158, 62)]), cat.fur, line: cat.dark, width: 4)
            Blob(poly([P(242, 108), P(232, 44), P(182, 70)]), earPink)

            // Hlavička
            Blob(oval(150, 150, 250, 205), radial([cat.furLight, cat.fur], 150, 118, 150),
                 line: cat.dark, width: 4)
            pattern

            // Tvářičky
            Blob(oval(66, 194, 44, 24), Color(hex: 0xFF8FB1).opacity(0.45))
            Blob(oval(234, 194, 44, 24), Color(hex: 0xFF8FB1).opacity(0.45))

            eye(100, outer: -1)
            eye(200, outer: 1)

            nose
            mouth
            whiskers
        }
    }

    @ViewBuilder private var pattern: some View {
        switch cat.pattern {
        case .tabby:
            Line(polyline(P(150, 52), P(150, 90)), cat.dark, 9)
            Line(polyline(P(121, 57), P(130, 86)), cat.dark, 7)
            Line(polyline(P(179, 57), P(170, 86)), cat.dark, 7)
            Line(polyline(P(28, 140), P(50, 146)), cat.dark, 5)
            Line(polyline(P(30, 160), P(50, 160)), cat.dark, 5)
            Line(polyline(P(272, 140), P(250, 146)), cat.dark, 5)
            Line(polyline(P(270, 160), P(250, 160)), cat.dark, 5)
        case .blaze:
            Blob(poly([P(140, 50), P(160, 50), P(174, 175), P(126, 175)]), Color.white.opacity(0.95))
            Blob(oval(150, 208, 136, 86), Color.white)
        case .patches:
            Blob(oval(203, 140, 108, 100), cat.patch)
            Blob(oval(96, 82, 66, 40), cat.patch)
        }
    }

    @ViewBuilder private func eye(_ cx: CGFloat, outer: CGFloat) -> some View {
        switch eyes {
        case .open:
            ZStack {
                Blob(oval(cx, 150, 78, 84), Color.white, line: cat.dark, width: 3)
                Blob(oval(cx, 154, 60, 66), radial([cat.eyeLight, cat.eye], cx, 168, 36))
                Blob(oval(cx, 154, 30, 38), ink)
                Blob(oval(cx - 10, 139, 16, 16), Color.white)
                Blob(oval(cx + 9, 165, 8, 8), Color.white.opacity(0.9))
                Line(polyline(P(cx + outer * 35, 130), P(cx + outer * 48, 120)), ink, 3.5)
                Line(polyline(P(cx + outer * 39, 141), P(cx + outer * 53, 135)), ink, 3.5)
            }
        case .closed:
            ZStack {
                Line(curve(P(cx - 32, 150), P(cx, 174), P(cx + 32, 150)), ink, 5)
                Line(polyline(P(cx + outer * 30, 154), P(cx + outer * 42, 162)), ink, 3)
                Line(polyline(P(cx + outer * 20, 162), P(cx + outer * 28, 172)), ink, 3)
            }
        case .happy:
            Line(curve(P(cx - 30, 160), P(cx, 128), P(cx + 30, 160)), ink, 6)
        }
    }

    private var nose: some View {
        var p = Path()
        p.move(to: P(139, 188))
        p.addQuadCurve(to: P(161, 188), control: P(150, 181))
        p.addQuadCurve(to: P(150, 200), control: P(161, 195))
        p.addQuadCurve(to: P(139, 188), control: P(139, 195))
        p.closeSubpath()
        return Blob(p, Color(hex: 0xF27A98), line: Color(hex: 0xC94F70), width: 2)
    }

    @ViewBuilder private var mouth: some View {
        if mouthOpen {
            Blob(oval(150, 216, 32, 28), Color(hex: 0x7A2335), line: ink, width: 2.5)
            Blob(oval(150, 225, 18, 9), Color(hex: 0xFF8FA8))
        } else {
            Line(polyline(P(150, 199), P(150, 205)), ink, 3)
            Line(mouthPath, ink, 3)
        }
    }

    private var mouthPath: Path {
        var p = Path()
        p.move(to: P(130, 203))
        p.addQuadCurve(to: P(150, 205), control: P(139, 218))
        p.addQuadCurve(to: P(170, 203), control: P(161, 218))
        return p
    }

    private var whiskers: some View {
        ZStack {
            ForEach(Array(whiskerLines.enumerated()), id: \.offset) { _, w in
                Line(polyline(P(w.0, w.1), P(w.2, w.3)), ink.opacity(0.85), 2.5)
                Line(polyline(P(300 - w.0, w.1), P(300 - w.2, w.3)), ink.opacity(0.85), 2.5)
            }
        }
    }

    private var whiskerLines: [(CGFloat, CGFloat, CGFloat, CGFloat)] {
        [(60, 182, 12, 172), (60, 190, 8, 193), (62, 198, 14, 213)]
    }
}

#Preview {
    HStack {
        ForEach(Cat.all) { cat in
            BoardView(height: 300) { CatView(cat: cat) }
        }
    }
    .padding()
    .background(Color(hex: 0xF7C9A8))
}
