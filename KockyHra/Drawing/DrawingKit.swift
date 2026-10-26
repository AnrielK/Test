import SwiftUI
import UIKit

// Všechny postavičky a doplňky se kreslí do pevného plátna 300 × 400 bodů
// (kočička stojí uprostřed). Díky tomu do sebe oblečení vždy přesně zapadne
// a celé plátno se pak jen zvětší nebo zmenší podle velikosti obrazovky.
enum Board {
    static let width: CGFloat = 300
    static let height: CGFloat = 400
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

// MARK: - Tvary

func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x, y: y) }

func oval(_ cx: CGFloat, _ cy: CGFloat, _ w: CGFloat, _ h: CGFloat) -> Path {
    Path(ellipseIn: CGRect(x: cx - w / 2, y: cy - h / 2, width: w, height: h))
}

func roundRect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ r: CGFloat) -> Path {
    Path(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerRadius: r)
}

func poly(_ points: [CGPoint]) -> Path {
    var p = Path()
    p.addLines(points)
    p.closeSubpath()
    return p
}

func polyline(_ points: CGPoint...) -> Path {
    var p = Path()
    p.addLines(points)
    return p
}

func curve(_ from: CGPoint, _ control: CGPoint, _ to: CGPoint) -> Path {
    var p = Path()
    p.move(to: from)
    p.addQuadCurve(to: to, control: control)
    return p
}

func starPath(_ cx: CGFloat, _ cy: CGFloat, outer: CGFloat, inner: CGFloat, points: Int = 5) -> Path {
    var pts: [CGPoint] = []
    for i in 0..<(points * 2) {
        let r = i.isMultiple(of: 2) ? outer : inner
        let a = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
        pts.append(P(cx + r * cos(a), cy + r * sin(a)))
    }
    return poly(pts)
}

func heartPath(_ cx: CGFloat, _ cy: CGFloat, _ s: CGFloat) -> Path {
    var p = Path()
    p.move(to: P(cx, cy + s * 0.38))
    p.addCurve(to: P(cx - s * 0.5, cy - s * 0.08),
               control1: P(cx - s * 0.18, cy + s * 0.2),
               control2: P(cx - s * 0.5, cy + s * 0.12))
    p.addCurve(to: P(cx, cy - s * 0.22),
               control1: P(cx - s * 0.5, cy - s * 0.42),
               control2: P(cx - s * 0.08, cy - s * 0.45))
    p.addCurve(to: P(cx + s * 0.5, cy - s * 0.08),
               control1: P(cx + s * 0.08, cy - s * 0.45),
               control2: P(cx + s * 0.5, cy - s * 0.42))
    p.addCurve(to: P(cx, cy + s * 0.38),
               control1: P(cx + s * 0.5, cy + s * 0.12),
               control2: P(cx + s * 0.18, cy + s * 0.2))
    p.closeSubpath()
    return p
}

// MARK: - Výplně v souřadnicích plátna

func radial(_ colors: [Color], _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat,
            in size: CGSize = CGSize(width: Board.width, height: Board.height)) -> RadialGradient {
    RadialGradient(colors: colors,
                   center: UnitPoint(x: cx / size.width, y: cy / size.height),
                   startRadius: 0, endRadius: r)
}

func vertical(_ colors: [Color], _ y0: CGFloat, _ y1: CGFloat,
              in size: CGSize = CGSize(width: Board.width, height: Board.height)) -> LinearGradient {
    LinearGradient(colors: colors,
                   startPoint: UnitPoint(x: 0.5, y: y0 / size.height),
                   endPoint: UnitPoint(x: 0.5, y: y1 / size.height))
}

// MARK: - Kreslicí kousky

/// Vyplněný tvar s kresleným obrysem.
struct Blob<S: ShapeStyle>: View {
    let path: Path
    let fill: S
    var line: Color?
    var width: CGFloat

    init(_ path: Path, _ fill: S, line: Color? = nil, width: CGFloat = 3) {
        self.path = path
        self.fill = fill
        self.line = line
        self.width = width
    }

    var body: some View {
        ZStack {
            path.fill(fill)
            if let line {
                path.stroke(line, style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

/// Zaoblená čára (vousky, pusa, švy).
struct Line: View {
    let path: Path
    let color: Color
    var width: CGFloat

    init(_ path: Path, _ color: Color, _ width: CGFloat = 3) {
        self.path = path
        self.color = color
        self.width = width
    }

    var body: some View {
        path.stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
    }
}

/// Tlustá čára s obrysem – tlapky, nožičky, ocásek.
struct Limb: View {
    let path: Path
    let color: Color
    let outline: Color
    let width: CGFloat

    var body: some View {
        ZStack {
            Line(path, outline, width + 6)
            Line(path, color, width)
        }
    }
}

// MARK: - Zvětšování plátna

/// Vykreslí obsah plátna 300 × 400 v dané výšce.
struct BoardView<Content: View>: View {
    let height: CGFloat
    @ViewBuilder var content: Content

    var body: some View {
        let s = height / Board.height
        content
            .frame(width: Board.width, height: Board.height)
            .scaleEffect(s)
            .frame(width: Board.width * s, height: height)
    }
}

/// Náhled jen jedné části plátna (např. čepice) v malém čtverečku.
struct RegionThumb<Content: View>: View {
    let region: CGRect
    let size: CGFloat
    @ViewBuilder var content: Content

    var body: some View {
        let s = size / max(region.width, region.height)
        content
            .frame(width: Board.width, height: Board.height)
            .offset(x: Board.width / 2 - region.midX, y: Board.height / 2 - region.midY)
            .scaleEffect(s)
            .frame(width: size, height: size)
            .clipped()
    }
}

/// Malá kresba v plátně 100 × 100 (jídlo, nástroje).
struct IconBoard<Content: View>: View {
    let size: CGFloat
    @ViewBuilder var content: Content

    var body: some View {
        content
            .frame(width: 100, height: 100)
            .scaleEffect(size / 100)
            .frame(width: size, height: size)
    }
}

let iconSize = CGSize(width: 100, height: 100)

// MARK: - Haptika

enum Haptics {
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func pop() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func nope() { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
}
