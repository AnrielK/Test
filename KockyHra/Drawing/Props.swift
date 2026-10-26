import SwiftUI

// Drobné kresby do plátna 100 × 100 (jídlo, nástroje, nečistoty).
// Zvětšují se pomocí `IconBoard(size:)`.

// MARK: - Jídlo

enum Food: String, CaseIterable, Identifiable {
    case fish, sausage, drumstick, milk, steak, cheese
    var id: String { rawValue }

    var name: String {
        switch self {
        case .fish: "rybičku"
        case .sausage: "párek"
        case .drumstick: "stehýnko"
        case .milk: "mlíčko"
        case .steak: "maso"
        case .cheese: "sýr"
        }
    }

    @ViewBuilder var drawing: some View {
        switch self {
        case .fish:
            let line = Color(hex: 0x1F5F99)
            ZStack {
                Blob(poly([P(72, 50), P(96, 28), P(90, 50), P(96, 72)]), Color(hex: 0x3A8FD0), line: line)
                Blob(poly([P(38, 34), P(52, 18), P(60, 34)]), Color(hex: 0x3A8FD0), line: line)
                Blob(oval(46, 50, 66, 40), radial([Color(hex: 0xA6DCFF), Color(hex: 0x3FA0E8)], 38, 42, 40, in: iconSize), line: line)
                Line(curve(P(54, 38), P(62, 50), P(54, 62)), line.opacity(0.5), 2.5)
                Blob(oval(26, 46, 11, 11), Color.white, line: line, width: 2)
                Blob(oval(25, 46, 5, 5), Color.black)
            }
        case .sausage:
            ZStack {
                Blob(oval(9, 50, 10, 12), Color(hex: 0xA8401E))
                Blob(oval(91, 50, 10, 12), Color(hex: 0xA8401E))
                Blob(roundRect(8, 36, 84, 28, 14), vertical([Color(hex: 0xEE8257), Color(hex: 0xC2502A)], 36, 64, in: iconSize),
                     line: Color(hex: 0x8E3418))
                Line(polyline(P(22, 43), P(70, 43)), Color.white.opacity(0.45), 4)
            }
        case .drumstick:
            ZStack {
                Limb(path: polyline(P(56, 56), P(80, 80)), color: .white, outline: Color(hex: 0xC9B9A8), width: 10)
                Blob(oval(86, 76, 15, 15), Color.white, line: Color(hex: 0xC9B9A8))
                Blob(oval(78, 88, 15, 15), Color.white, line: Color(hex: 0xC9B9A8))
                Blob(oval(42, 44, 60, 54), radial([Color(hex: 0xF5B866), Color(hex: 0xC97528)], 34, 34, 44, in: iconSize),
                     line: Color(hex: 0x8A4A12))
                Blob(oval(32, 32, 16, 9), Color.white.opacity(0.45))
            }
        case .milk:
            let line = Color(hex: 0x5A8AD0)
            ZStack {
                Blob(roundRect(28, 32, 44, 60, 5), Color.white, line: line)
                Blob(poly([P(28, 32), P(50, 12), P(72, 32)]), Color(hex: 0x9FD0FF), line: line)
                Blob(roundRect(28, 52, 44, 24, 0), Color(hex: 0x4FA8FF))
                Blob(heartPath(50, 64, 16), Color.white)
            }
        case .steak:
            ZStack {
                Blob(oval(50, 52, 82, 58), radial([Color(hex: 0xFF8E99), Color(hex: 0xD94456)], 40, 44, 50, in: iconSize),
                     line: Color(hex: 0x9E2433))
                Line(curve(P(28, 54), P(50, 26), P(72, 54)), Color.white.opacity(0.85), 5)
                Line(curve(P(40, 58), P(50, 44), P(60, 58)), Color.white.opacity(0.85), 4)
            }
        case .cheese:
            let line = Color(hex: 0xD19A12)
            ZStack {
                Blob(poly([P(12, 74), P(88, 74), P(88, 40), P(12, 60)]),
                     vertical([Color(hex: 0xFFE680), Color(hex: 0xFFC23F)], 40, 74, in: iconSize), line: line)
                Blob(oval(32, 66, 11, 8), line.opacity(0.45))
                Blob(oval(58, 60, 13, 10), line.opacity(0.45))
                Blob(oval(78, 67, 8, 6), line.opacity(0.45))
            }
        }
    }
}

// MARK: - Záchodek

struct PoopDrawing: View {
    var body: some View {
        let fill = Color(hex: 0x8A5A3A)
        let line = Color(hex: 0x5A3A22)
        ZStack {
            Blob(oval(50, 72, 66, 28), fill, line: line)
            Blob(oval(50, 54, 50, 24), fill, line: line)
            Blob(oval(52, 38, 30, 20), fill, line: line)
            Blob(oval(42, 50, 12, 6), Color.white.opacity(0.3))
        }
    }
}

/// Lopatka. Hlava lopatky je v bodě (34, 63) – to je místo, kterým se sbírá.
struct ScoopDrawing: View {
    var carried = 0

    var body: some View {
        let line = Color(hex: 0x2E8A2E)
        ZStack {
            Limb(path: polyline(P(56, 56), P(94, 16)), color: Color(hex: 0x5FD35F), outline: line, width: 11)
            Blob(roundRect(8, 40, 54, 46, 10), vertical([Color(hex: 0x8CF08C), Color(hex: 0x4CC24C)], 40, 86, in: iconSize),
                 line: line)
            ForEach(0..<4, id: \.self) { i in
                Line(polyline(P(18 + CGFloat(i) * 11, 50), P(18 + CGFloat(i) * 11, 76)), line.opacity(0.45), 3)
            }
            ForEach(0..<carried, id: \.self) { i in
                IconBoard(size: 24) { PoopDrawing() }
                    .position(x: 22 + CGFloat(i % 2) * 22, y: 70 - CGFloat(i / 2) * 14)
            }
        }
    }
}

struct BinDrawing: View {
    var body: some View {
        let line = Color(hex: 0x1F62C2)
        ZStack {
            Blob(poly([P(14, 24), P(86, 24), P(78, 94), P(22, 94)]),
                 vertical([Color(hex: 0x7CC6FF), Color(hex: 0x3A8FE8)], 24, 94, in: iconSize), line: line)
            Blob(roundRect(8, 16, 84, 14, 7), Color(hex: 0xBFE4FF), line: line)
            Image(systemName: "arrow.3.trianglepath")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.9))
                .position(x: 50, y: 60)
        }
    }
}

/// Bedýnka s pískem – roztáhne se na zadanou velikost.
struct LitterBoxView: View {
    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                RoundedRectangle(cornerRadius: h * 0.22).fill(Color(hex: 0x5AAEF0)).offset(y: h * 0.06)
                RoundedRectangle(cornerRadius: h * 0.22).fill(Color.white)
                RoundedRectangle(cornerRadius: h * 0.22).strokeBorder(Color(hex: 0x3A8FD0), lineWidth: 4)
                RoundedRectangle(cornerRadius: h * 0.15)
                    .fill(LinearGradient(colors: [Color(hex: 0xF9E49A), Color(hex: 0xE9C462)], startPoint: .top, endPoint: .bottom))
                    .padding(h * 0.09)
                Canvas { ctx, size in
                    for i in 0..<90 {
                        let fx = 0.12 + 0.76 * abs(sin(Double(i) * 12.9898))
                        let fy = 0.16 + 0.68 * abs(sin(Double(i) * 78.233))
                        let r = 2 + 2 * abs(sin(Double(i) * 3.7))
                        let rect = CGRect(x: fx * size.width, y: fy * size.height, width: r, height: r)
                        ctx.fill(Path(ellipseIn: rect), with: .color(Color(hex: 0xC9A040).opacity(0.6)))
                    }
                }
                Image(systemName: "pawprint.fill")
                    .font(.system(size: h * 0.12))
                    .foregroundStyle(Color(hex: 0x3A8FD0))
                    .position(x: w * 0.88, y: h * 0.93)
            }
        }
    }
}

// MARK: - Koupání a česání

enum GroomTool: CaseIterable, Identifiable {
    case comb, sponge, shower
    var id: Self { self }

    var hint: String {
        switch self {
        case .comb: "Hřebenem vyčeš lístky"
        case .sponge: "Houbičkou umyj bláto"
        case .shower: "Sprchou opláchni pěnu"
        }
    }

    @ViewBuilder var drawing: some View {
        switch self {
        case .comb:
            let line = Color(hex: 0xC43C7E)
            ZStack {
                ForEach(0..<9, id: \.self) { i in
                    Line(polyline(P(18 + CGFloat(i) * 8, 50), P(18 + CGFloat(i) * 8, 80)), line, 4)
                }
                Blob(roundRect(10, 26, 80, 28, 10), vertical([Color(hex: 0xFFA3CF), Color(hex: 0xFF6FAE)], 26, 54, in: iconSize),
                     line: line)
            }
        case .sponge:
            let line = Color(hex: 0xD19A12)
            ZStack {
                Blob(roundRect(12, 28, 76, 50, 16), vertical([Color(hex: 0xFFF08A), Color(hex: 0xFFD23F)], 28, 78, in: iconSize),
                     line: line)
                Blob(oval(30, 44, 10, 8), line.opacity(0.4))
                Blob(oval(56, 40, 8, 6), line.opacity(0.4))
                Blob(oval(68, 60, 12, 9), line.opacity(0.4))
                Blob(oval(40, 62, 8, 6), line.opacity(0.4))
            }
        case .shower:
            let line = Color(hex: 0x6A7A90)
            ZStack {
                Limb(path: polyline(P(50, 42), P(82, 88)), color: Color(hex: 0xD8E2EE), outline: line, width: 10)
                Blob(oval(40, 34, 56, 34), vertical([Color.white, Color(hex: 0xB8C6D8)], 18, 52, in: iconSize), line: line)
                ForEach(0..<3, id: \.self) { i in
                    Blob(oval(26 + CGFloat(i) * 14, 62 + CGFloat(i % 2) * 8, 8, 12), Color(hex: 0x6CC0FF))
                }
            }
        }
    }
}

enum DirtKind {
    case leaf, mud, bubbles
}

struct DirtDrawing: View {
    let kind: DirtKind

    var body: some View {
        switch kind {
        case .leaf:
            ZStack {
                Blob(leaf, vertical([Color(hex: 0x8EE06A), Color(hex: 0x3FAE3A)], 20, 80, in: iconSize), line: Color(hex: 0x2E7A22))
                Line(polyline(P(16, 50), P(82, 50)), Color(hex: 0x2E7A22), 3)
                Line(polyline(P(40, 50), P(52, 36)), Color(hex: 0x2E7A22).opacity(0.7), 2)
                Line(polyline(P(56, 50), P(66, 62)), Color(hex: 0x2E7A22).opacity(0.7), 2)
            }
        case .mud:
            let mud = Color(hex: 0x8A5A3A).opacity(0.9)
            ZStack {
                Blob(oval(50, 54, 72, 50), mud)
                Blob(oval(28, 38, 32, 28), mud)
                Blob(oval(74, 72, 28, 22), mud)
                Blob(oval(80, 34, 14, 12), mud)
                Blob(oval(40, 46, 14, 8), Color.white.opacity(0.25))
            }
        case .bubbles:
            let line = Color(hex: 0x9FD8FF)
            ZStack {
                Blob(oval(40, 52, 44, 44), Color.white.opacity(0.9), line: line)
                Blob(oval(68, 40, 30, 30), Color.white.opacity(0.9), line: line)
                Blob(oval(64, 70, 32, 32), Color.white.opacity(0.9), line: line)
                Blob(oval(26, 76, 20, 20), Color.white.opacity(0.9), line: line)
                Blob(oval(32, 42, 10, 8), Color(hex: 0xBFE8FF))
                Blob(oval(64, 34, 7, 5), Color(hex: 0xBFE8FF))
            }
        }
    }

    private var leaf: Path {
        var p = Path()
        p.move(to: P(12, 50))
        p.addQuadCurve(to: P(88, 50), control: P(50, 6))
        p.addQuadCurve(to: P(12, 50), control: P(50, 94))
        p.closeSubpath()
        return p
    }
}

// MARK: - Nábytek

/// Žluté křesílko za kočičkou – kreslí se do plátna kočičky (300 × 400).
struct ArmchairDrawing: View {
    var body: some View {
        let line = Color(hex: 0xD9A520)
        let fill = vertical([Color(hex: 0xFFE07A), Color(hex: 0xFFC83F)], 140, 390)
        ZStack {
            Blob(roundRect(26, 140, 248, 220, 60), fill, line: line, width: 5)
            Blob(roundRect(14, 300, 272, 92, 30), fill, line: line, width: 5)
            Blob(roundRect(-6, 230, 64, 160, 30), fill, line: line, width: 5)
            Blob(roundRect(242, 230, 64, 160, 30), fill, line: line, width: 5)
            Blob(oval(26, 240, 18, 12), Color.white.opacity(0.4))
            Blob(oval(274, 240, 18, 12), Color.white.opacity(0.4))
        }
    }
}

/// Myšlenková bublina.
struct ThoughtBubble<Content: View>: View {
    let size: CGFloat
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: size * 0.14, height: size * 0.14)
                .offset(x: -size * 0.5, y: size * 0.42)
            Circle().fill(.white).frame(width: size * 0.22, height: size * 0.22)
                .offset(x: -size * 0.36, y: size * 0.3)
            Ellipse().fill(.white).frame(width: size, height: size * 0.75)
            content
        }
        .shadow(color: .black.opacity(0.15), radius: 3, y: 3)
    }
}
