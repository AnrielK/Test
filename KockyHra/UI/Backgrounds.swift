import SwiftUI

/// Pokoj: pruhovaná tapeta, lišta a podlaha, volitelně závěsy.
struct RoomBackground: View {
    var wallA = Color(hex: 0xF7CBAA)
    var wallB = Color(hex: 0xF2BC9B)
    var trim = Color(hex: 0xE59A6A)
    var floor = Color(hex: 0xB06B58)
    var floorDark = Color(hex: 0x95543F)
    var horizon: CGFloat = 0.55
    var curtains: Color? = Color(hex: 0xA052B8)
    var tiled = false

    var body: some View {
        GeometryReader { g in
            let h = g.size.height
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Group {
                        if tiled {
                            TileWall(color: wallA, line: wallB)
                        } else {
                            HStack(spacing: 0) {
                                ForEach(0..<14, id: \.self) { i in
                                    (i.isMultiple(of: 2) ? wallA : wallB)
                                }
                            }
                        }
                    }
                    .frame(height: h * horizon)
                    trim.frame(height: h * 0.035)
                    ZStack {
                        LinearGradient(colors: [floor, floorDark], startPoint: .top, endPoint: .bottom)
                        FloorBoards(color: floorDark.opacity(0.35))
                    }
                }
                if let curtains {
                    Curtains(color: curtains)
                }
            }
        }
        .ignoresSafeArea()
    }
}

/// Dlaždičky (koupelna, jeviště).
struct TileWall: View {
    let color: Color
    let line: Color
    var tile: CGFloat = 70
    var diagonal = false

    var body: some View {
        Canvas { ctx, size in
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(color))
            var p = Path()
            if diagonal {
                var x: CGFloat = -size.height
                while x < size.width + size.height {
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x + size.height, y: size.height))
                    p.move(to: CGPoint(x: x + size.height, y: 0))
                    p.addLine(to: CGPoint(x: x, y: size.height))
                    x += tile
                }
            } else {
                var x: CGFloat = 0
                while x < size.width {
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x, y: size.height))
                    x += tile
                }
                var y: CGFloat = 0
                while y < size.height {
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: size.width, y: y))
                    y += tile
                }
            }
            ctx.stroke(p, with: .color(line), lineWidth: 3)
        }
    }
}

struct FloorBoards: View {
    let color: Color

    var body: some View {
        Canvas { ctx, size in
            var p = Path()
            var y: CGFloat = size.height * 0.25
            var row = 0
            while y < size.height {
                p.move(to: CGPoint(x: 0, y: y))
                p.addQuadCurve(to: CGPoint(x: size.width, y: y + 6), control: CGPoint(x: size.width / 2, y: y - 10))
                let offset: CGFloat = row.isMultiple(of: 2) ? 0.3 : 0.65
                p.move(to: CGPoint(x: size.width * offset, y: y))
                p.addLine(to: CGPoint(x: size.width * offset - 8, y: y + size.height * 0.25))
                y += size.height * 0.28
                row += 1
            }
            ctx.stroke(p, with: .color(color), lineWidth: 2.5)
        }
    }
}

/// Fialové závěsy v horních rozích.
struct Curtains: View {
    let color: Color

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            let fill = LinearGradient(colors: [color.opacity(0.95), color], startPoint: .top, endPoint: .bottom)
            ZStack {
                curtain(w: w, h: h).fill(fill)
                curtain(w: w, h: h).stroke(Color.white.opacity(0.15), lineWidth: 3)
                curtain(w: w, h: h).fill(fill).scaleEffect(x: -1, y: 1)
                folds(w: w, h: h).stroke(Color.black.opacity(0.12), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                folds(w: w, h: h).stroke(Color.black.opacity(0.12), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .scaleEffect(x: -1, y: 1)
            }
        }
        .allowsHitTesting(false)
    }

    private func curtain(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.move(to: .zero)
        p.addLine(to: CGPoint(x: w * 0.25, y: 0))
        p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.45), control: CGPoint(x: w * 0.16, y: h * 0.34))
        p.closeSubpath()
        return p
    }

    private func folds(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: w * 0.06, y: 0))
        p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.25), control: CGPoint(x: w * 0.06, y: h * 0.18))
        p.move(to: CGPoint(x: w * 0.14, y: 0))
        p.addQuadCurve(to: CGPoint(x: w * 0.03, y: h * 0.36), control: CGPoint(x: w * 0.12, y: h * 0.25))
        return p
    }
}

/// Divadelní opona po stranách (výběr kočičky).
struct StageCurtains: View {
    var color = Color(hex: 0xE04FC0)

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                side(w: w, h: h)
                side(w: w, h: h).scaleEffect(x: -1, y: 1)
            }
        }
        .allowsHitTesting(false)
    }

    private func side(w: CGFloat, h: CGFloat) -> some View {
        var p = Path()
        p.move(to: .zero)
        p.addLine(to: CGPoint(x: w * 0.18, y: 0))
        p.addQuadCurve(to: CGPoint(x: w * 0.09, y: h), control: CGPoint(x: w * 0.06, y: h * 0.5))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        var f = Path()
        f.move(to: CGPoint(x: w * 0.05, y: 0))
        f.addQuadCurve(to: CGPoint(x: w * 0.03, y: h), control: CGPoint(x: w * 0.01, y: h * 0.5))
        f.move(to: CGPoint(x: w * 0.11, y: 0))
        f.addQuadCurve(to: CGPoint(x: w * 0.06, y: h), control: CGPoint(x: w * 0.04, y: h * 0.5))
        return ZStack {
            p.fill(LinearGradient(colors: [color, color.opacity(0.85)], startPoint: .leading, endPoint: .trailing))
            f.stroke(Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 8, lineCap: .round))
        }
    }
}

/// Kulatý kobereček s krajkou.
struct Rug: View {
    var color = Color(hex: 0xB56BE0)
    var inner = Color(hex: 0xA052D6)
    var lace = Color(hex: 0xFFE8F2)

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                ForEach(0..<32, id: \.self) { i in
                    let a = CGFloat(i) / 32 * 2 * .pi
                    Circle()
                        .fill(lace)
                        .frame(width: h * 0.2, height: h * 0.2)
                        .position(x: w / 2 + cos(a) * w * 0.45, y: h / 2 + sin(a) * h * 0.42)
                }
                Ellipse().fill(lace).frame(width: w * 0.94, height: h * 0.88)
                Ellipse().fill(color).frame(width: w * 0.86, height: h * 0.76)
                Ellipse().fill(inner).frame(width: w * 0.58, height: h * 0.48)
            }
            .frame(width: w, height: h)
        }
    }
}

/// Podstavec na jevišti (zlatý okraj, růžový vršek).
struct Pedestal: View {
    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                Ellipse().fill(Color(hex: 0xE8B33A)).frame(width: w, height: h * 0.8).offset(y: h * 0.1)
                Ellipse().fill(Color(hex: 0xFFD25A)).frame(width: w, height: h * 0.8)
                Ellipse().fill(Color(hex: 0xF070B4)).frame(width: w * 0.9, height: h * 0.68)
                Ellipse().fill(Color(hex: 0xD9559D)).frame(width: w * 0.6, height: h * 0.42)
            }
            .frame(width: w, height: h)
        }
    }
}
