import SwiftUI

struct Outfit: Codable, Equatable {
    var hat: Hat?
    var glasses: Glasses?
    var shirt: Shirt?
    var pants: Pants?
    var shoes: Shoes?
}

// Každý doplněk se kreslí přímo v souřadnicích kočičky (plátno 300 × 400),
// takže sedí na správném místě. Náhledy v šatníku jen vyříznou jeho oblast.

// MARK: - Čepice

enum Hat: String, CaseIterable, Codable, Identifiable {
    case cap, beret, crown, bow, sunHat, police, beanie, party
    var id: String { rawValue }

    @ViewBuilder var view: some View {
        switch self {
        case .cap:
            let line = Color(hex: 0x1E45A8)
            ZStack {
                Blob(dome(78, 222, base: 100, top: 22), vertical([Color(hex: 0x6FA8FF), Color(hex: 0x2F68E0)], 30, 100), line: line, width: 4)
                Blob(dome(118, 182, base: 100, top: 36), Color.white.opacity(0.9))
                Blob(oval(212, 100, 120, 24), Color(hex: 0x2756C8), line: line, width: 4)
                Blob(oval(150, 38, 18, 12), Color(hex: 0x2756C8), line: line, width: 3)
            }
        case .beret:
            let line = Color(hex: 0x9E1E2B)
            ZStack {
                Blob(roundRect(146, 30, 8, 16, 3), Color(hex: 0xB82634))
                Blob(oval(150, 70, 204, 64), radial([Color(hex: 0xFF6B78), Color(hex: 0xD92A3B)], 130, 55, 110), line: line, width: 4)
                Blob(roundRect(88, 84, 124, 14, 7), Color(hex: 0xA81E2C))
                Blob(starPath(205, 78, outer: 13, inner: 6), Color(hex: 0xFFE14D), line: Color(hex: 0xC98A10), width: 2)
            }
        case .crown:
            let line = Color(hex: 0xC98A10)
            ZStack {
                Blob(poly([P(88, 98), P(88, 48), P(118, 72), P(150, 30), P(182, 72), P(212, 48), P(212, 98)]),
                     vertical([Color(hex: 0xFFF08A), Color(hex: 0xFFC21F)], 30, 98), line: line, width: 4)
                Blob(oval(88, 44, 14, 14), Color(hex: 0xFFE14D), line: line, width: 2.5)
                Blob(oval(150, 26, 14, 14), Color(hex: 0xFFE14D), line: line, width: 2.5)
                Blob(oval(212, 44, 14, 14), Color(hex: 0xFFE14D), line: line, width: 2.5)
                Blob(oval(150, 80, 18, 22), Color(hex: 0xFF3B6B), line: line, width: 2)
                Blob(oval(114, 85, 12, 12), Color(hex: 0x3FA9FF), line: line, width: 2)
                Blob(oval(186, 85, 12, 12), Color(hex: 0x3FD07A), line: line, width: 2)
            }
        case .bow:
            let fill = vertical([Color(hex: 0xFF9BCB), Color(hex: 0xFF4FA0)], 30, 95)
            let line = Color(hex: 0xC23E7E)
            ZStack {
                Blob(poly([P(205, 64), P(158, 34), P(162, 96)]), fill, line: line, width: 5)
                Blob(poly([P(205, 64), P(252, 34), P(248, 96)]), fill, line: line, width: 5)
                Blob(oval(205, 64, 24, 24), Color(hex: 0xFF4FA0), line: line, width: 3)
            }
        case .sunHat:
            let straw = Color(hex: 0xF5C45A)
            let line = Color(hex: 0xB5862A)
            ZStack {
                Blob(oval(150, 82, 266, 46), straw, line: line, width: 4)
                Blob(dome(98, 202, base: 82, top: 14), straw, line: line, width: 4)
                Blob(roundRect(99, 62, 102, 14, 4), Color(hex: 0xE85A9B))
                Blob(starPath(190, 68, outer: 14, inner: 7, points: 6), Color.white, line: Color(hex: 0xE85A9B), width: 2)
                Blob(oval(190, 68, 7, 7), Color(hex: 0xFFD23F))
            }
        case .police:
            ZStack {
                Blob(oval(150, 54, 206, 58), Color(hex: 0x1F2440), line: .black, width: 4)
                Blob(roundRect(92, 62, 116, 30, 8), Color(hex: 0x2A2F55), line: .black, width: 3)
                Blob(curvedVisor, Color(hex: 0x111111), line: .black, width: 3)
                Blob(starPath(150, 56, outer: 18, inner: 8), Color.white, line: Color(hex: 0xC9C9D6), width: 2)
            }
        case .beanie:
            let line = Color(hex: 0x1F3CA8)
            ZStack {
                Blob(dome(80, 220, base: 98, top: 14), vertical([Color(hex: 0x6E8BFF), Color(hex: 0x3459E0)], 20, 98), line: line, width: 4)
                Line(polyline(P(120, 50), P(120, 86)), line.opacity(0.35), 4)
                Line(polyline(P(150, 42), P(150, 86)), line.opacity(0.35), 4)
                Line(polyline(P(180, 50), P(180, 86)), line.opacity(0.35), 4)
                Blob(roundRect(72, 82, 156, 28, 14), Color(hex: 0xA9C8FF), line: line, width: 4)
                Blob(oval(150, 26, 36, 36), Color(hex: 0xDDE8FF), line: line, width: 3)
            }
        case .party:
            let cone = poly([P(108, 96), P(150, -6), P(192, 96)])
            ZStack {
                cone.fill(Color(hex: 0x7B5CFF))
                ZStack {
                    Rectangle().fill(Color(hex: 0xFFD23F)).frame(width: 300, height: 12).position(x: 150, y: 20)
                    Rectangle().fill(Color(hex: 0xFF5FA2)).frame(width: 300, height: 12).position(x: 150, y: 48)
                    Rectangle().fill(Color(hex: 0x3FD0C9)).frame(width: 300, height: 12).position(x: 150, y: 76)
                }
                .clipShape(cone)
                Line(cone, Color(hex: 0x4A2FB8), 4)
                Blob(oval(150, -8, 26, 26), Color(hex: 0xFFE14D), line: Color(hex: 0xC98A10), width: 3)
            }
        }
    }

    private func dome(_ x0: CGFloat, _ x1: CGFloat, base: CGFloat, top: CGFloat) -> Path {
        var p = Path()
        p.move(to: P(x0, base))
        p.addCurve(to: P(x1, base), control1: P(x0 + 4, top), control2: P(x1 - 4, top))
        p.closeSubpath()
        return p
    }

    private var curvedVisor: Path {
        var p = Path()
        p.move(to: P(94, 88))
        p.addQuadCurve(to: P(206, 88), control: P(150, 122))
        p.addQuadCurve(to: P(94, 88), control: P(150, 100))
        p.closeSubpath()
        return p
    }
}

// MARK: - Brýle

enum Glasses: String, CaseIterable, Codable, Identifiable {
    case starYellow, starBlue, sunRed, heartOrange, heartPink, sunGreen, round, big
    var id: String { rawValue }

    @ViewBuilder var view: some View {
        switch self {
        case .starYellow: stars(lens: Color(hex: 0xFFE14D), frame: Color(hex: 0xFF8A1E))
        case .starBlue: stars(lens: Color(hex: 0x8ED8FF), frame: Color(hex: 0x3AA0E8))
        case .heartOrange: hearts(lens: Color(hex: 0xFFB347), frame: Color(hex: 0xE07A10))
        case .heartPink: hearts(lens: Color(hex: 0xFF4FD8), frame: Color(hex: 0xB0209A))
        case .sunRed: shades(dark: Color(hex: 0x7A1010), light: Color(hex: 0xE23C3C), frame: Color(hex: 0x3A1010))
        case .sunGreen: shades(dark: Color(hex: 0x0E5A1E), light: Color(hex: 0x3CC25A), frame: Color(hex: 0x10351A))
        case .round:
            ZStack {
                bridge(Color(hex: 0x3A2A20))
                Blob(oval(100, 150, 94, 94), Color.white.opacity(0.18), line: Color(hex: 0x3A2A20), width: 6)
                Blob(oval(200, 150, 94, 94), Color.white.opacity(0.18), line: Color(hex: 0x3A2A20), width: 6)
            }
        case .big:
            ZStack {
                bridge(Color(hex: 0x6A3A1A))
                Blob(roundRect(42, 102, 112, 98, 20), Color(hex: 0x7B3B1A).opacity(0.4), line: Color(hex: 0x6A3A1A), width: 7)
                Blob(roundRect(146, 102, 112, 98, 20), Color(hex: 0x7B3B1A).opacity(0.4), line: Color(hex: 0x6A3A1A), width: 7)
                shine(60, 110)
                shine(164, 110)
            }
        }
    }

    private func bridge(_ color: Color) -> some View {
        Line(curve(P(140, 142), P(150, 132), P(160, 142)), color, 6)
    }

    private func shine(_ x: CGFloat, _ y: CGFloat) -> some View {
        Line(polyline(P(x, y + 50), P(x + 40, y + 6)), Color.white.opacity(0.45), 8)
    }

    private func stars(lens: Color, frame: Color) -> some View {
        ZStack {
            bridge(frame)
            Blob(starPath(100, 150, outer: 52, inner: 28), lens.opacity(0.55), line: frame, width: 7)
            Blob(starPath(200, 150, outer: 52, inner: 28), lens.opacity(0.55), line: frame, width: 7)
        }
    }

    private func hearts(lens: Color, frame: Color) -> some View {
        ZStack {
            bridge(frame)
            Blob(heartPath(98, 156, 110), lens.opacity(0.55), line: frame, width: 7)
            Blob(heartPath(202, 156, 110), lens.opacity(0.55), line: frame, width: 7)
        }
    }

    private func shades(dark: Color, light: Color, frame: Color) -> some View {
        let fill = LinearGradient(colors: [dark, light, dark], startPoint: .top, endPoint: .bottom)
        return ZStack {
            bridge(frame)
            Blob(roundRect(50, 116, 96, 66, 22), fill.opacity(0.88), line: frame, width: 6)
            Blob(roundRect(154, 116, 96, 66, 22), fill.opacity(0.88), line: frame, width: 6)
            shine(64, 116)
            shine(168, 116)
        }
    }
}

// MARK: - Trička a šaty

enum Shirt: String, CaseIterable, Codable, Identifiable {
    case pinkHeart, blueStar, stripes, suit, dress, hoodie
    var id: String { rawValue }

    @ViewBuilder var view: some View {
        switch self {
        case .pinkHeart:
            ZStack {
                Blob(Shirt.tee, Color(hex: 0xFF7BB8), line: Color(hex: 0xC43C7E), width: 3.5)
                Blob(heartPath(150, 296, 40), Color.white)
            }
        case .blueStar:
            ZStack {
                Blob(Shirt.tee, Color(hex: 0x4FA8FF), line: Color(hex: 0x1F62C2), width: 3.5)
                Blob(starPath(150, 294, outer: 22, inner: 10), Color(hex: 0xFFE14D), line: Color(hex: 0xD19A12), width: 2)
            }
        case .stripes:
            ZStack {
                Shirt.tee.fill(Color.white)
                VStack(spacing: 12) {
                    ForEach(0..<10, id: \.self) { _ in
                        Rectangle().fill(Color(hex: 0xFF5A5A)).frame(height: 10)
                    }
                }
                .frame(width: 300, height: 220)
                .position(x: 150, y: 300)
                .clipShape(Shirt.tee)
                Line(Shirt.tee, Color(hex: 0xB82A2A), 3.5)
            }
        case .suit:
            ZStack {
                Blob(Shirt.tee, Color(hex: 0x23232E), line: .black, width: 3.5)
                Blob(poly([P(128, 240), P(172, 240), P(150, 296)]), Color.white)
                Blob(poly([P(144, 250), P(156, 250), P(160, 286), P(150, 298), P(140, 286)]), Color(hex: 0xE23C3C))
                Blob(oval(150, 312, 8, 8), Color(hex: 0xC9C9D6))
                Blob(oval(150, 328, 8, 8), Color(hex: 0xC9C9D6))
                Blob(roundRect(176, 292, 16, 6, 2), Color(hex: 0xE23C3C))
            }
        case .dress:
            ZStack {
                Blob(Shirt.dressPath, vertical([Color(hex: 0xFFE680), Color(hex: 0xFFC23F)], 240, 365), line: Color(hex: 0xC98A10), width: 3.5)
                ForEach(Array(Shirt.dots.enumerated()), id: \.offset) { _, d in
                    Blob(oval(d.x, d.y, 11, 11), Color.white)
                }
                Blob(roundRect(100, 296, 100, 10, 5), Color(hex: 0xFF7BB8))
            }
        case .hoodie:
            ZStack {
                Blob(Shirt.tee, Color(hex: 0x4CC970), line: Color(hex: 0x23863F), width: 3.5)
                Blob(roundRect(116, 300, 68, 28, 12), Color(hex: 0x3AAE5B), line: Color(hex: 0x23863F), width: 2.5)
                Line(polyline(P(140, 246), P(138, 276)), Color.white, 3)
                Line(polyline(P(160, 246), P(162, 276)), Color.white, 3)
            }
        }
    }

    static let tee: Path = {
        var p = Path()
        p.move(to: P(122, 238))
        p.addQuadCurve(to: P(178, 238), control: P(150, 258))
        p.addLine(to: P(205, 246))
        p.addLine(to: P(234, 282))
        p.addLine(to: P(212, 300))
        p.addLine(to: P(202, 288))
        p.addLine(to: P(204, 338))
        p.addQuadCurve(to: P(96, 338), control: P(150, 350))
        p.addLine(to: P(98, 288))
        p.addLine(to: P(88, 300))
        p.addLine(to: P(66, 282))
        p.addLine(to: P(95, 246))
        p.closeSubpath()
        return p
    }()

    static let dressPath: Path = {
        var p = Path()
        p.move(to: P(122, 238))
        p.addQuadCurve(to: P(178, 238), control: P(150, 258))
        p.addLine(to: P(205, 246))
        p.addLine(to: P(234, 282))
        p.addLine(to: P(212, 300))
        p.addLine(to: P(202, 290))
        p.addLine(to: P(200, 302))
        p.addLine(to: P(230, 360))
        p.addQuadCurve(to: P(70, 360), control: P(150, 378))
        p.addLine(to: P(100, 302))
        p.addLine(to: P(98, 290))
        p.addLine(to: P(88, 300))
        p.addLine(to: P(66, 282))
        p.addLine(to: P(95, 246))
        p.closeSubpath()
        return p
    }()

    static let dots: [CGPoint] = [
        P(126, 270), P(174, 270), P(150, 282), P(110, 330), P(150, 340), P(190, 330), P(130, 318), P(170, 318), P(92, 350), P(208, 350),
    ]
}

// MARK: - Kalhoty a sukně

enum Pants: String, CaseIterable, Codable, Identifiable {
    case shortsBlue, shortsPink, jeans, skirt, tutu
    var id: String { rawValue }

    @ViewBuilder var view: some View {
        switch self {
        case .shortsBlue:
            Blob(Pants.shorts(bottom: 358), Color(hex: 0x3E6FE0), line: Color(hex: 0x1F3F99), width: 3.5)
        case .shortsPink:
            Blob(Pants.shorts(bottom: 358), Color(hex: 0xFF8AC4), line: Color(hex: 0xC43C7E), width: 3.5)
        case .jeans:
            ZStack {
                Blob(Pants.shorts(bottom: 374), Color(hex: 0x4A78C2), line: Color(hex: 0x24427A), width: 3.5)
                Line(polyline(P(110, 330), P(112, 370)), Color(hex: 0xF5C45A).opacity(0.8), 2)
                Line(polyline(P(190, 330), P(188, 370)), Color(hex: 0xF5C45A).opacity(0.8), 2)
            }
        case .skirt:
            ZStack {
                Blob(poly([P(100, 322), P(200, 322), P(224, 362), P(76, 362)]), Color(hex: 0xB05CE0), line: Color(hex: 0x6E2D9E), width: 3.5)
                Line(polyline(P(126, 324), P(116, 360)), Color(hex: 0x6E2D9E).opacity(0.5), 2.5)
                Line(polyline(P(150, 324), P(150, 362)), Color(hex: 0x6E2D9E).opacity(0.5), 2.5)
                Line(polyline(P(174, 324), P(184, 360)), Color(hex: 0x6E2D9E).opacity(0.5), 2.5)
            }
        case .tutu:
            ZStack {
                Blob(oval(150, 344, 170, 40), Color(hex: 0xFFB3D9), line: Color(hex: 0xE57BB0), width: 3)
                Blob(oval(150, 336, 150, 32), Color(hex: 0xFFCCE6), line: Color(hex: 0xE57BB0), width: 3)
                Blob(roundRect(100, 318, 100, 14, 7), Color(hex: 0xFF7BB8))
            }
        }
    }

    static func shorts(bottom: CGFloat) -> Path {
        poly([P(98, 320), P(202, 320), P(208, bottom), P(158, bottom + 2), P(150, 346), P(142, bottom + 2), P(92, bottom)])
    }
}

// MARK: - Botičky

enum Shoes: String, CaseIterable, Codable, Identifiable {
    case sneakersBlack, sneakersPink, boots, slippers
    var id: String { rawValue }

    @ViewBuilder var view: some View {
        switch self {
        case .sneakersBlack:
            ZStack { sneaker(124, Color(hex: 0x23232E)); sneaker(176, Color(hex: 0x23232E)) }
        case .sneakersPink:
            ZStack { sneaker(124, Color(hex: 0xFF6FAE)); sneaker(176, Color(hex: 0xFF6FAE)) }
        case .boots:
            ZStack { boot(124); boot(176) }
        case .slippers:
            ZStack { slipper(124); slipper(176) }
        }
    }

    private func sneaker(_ cx: CGFloat, _ color: Color) -> some View {
        ZStack {
            Blob(roundRect(cx - 24, 364, 48, 28, 14), color, line: .black.opacity(0.6), width: 3)
            Blob(roundRect(cx - 26, 384, 52, 9, 4.5), Color.white, line: .black.opacity(0.4), width: 2)
            Line(polyline(P(cx - 10, 370), P(cx + 10, 378)), Color.white, 3)
            Line(polyline(P(cx + 10, 370), P(cx - 10, 378)), Color.white, 3)
        }
    }

    private func boot(_ cx: CGFloat) -> some View {
        ZStack {
            Blob(roundRect(cx - 23, 344, 46, 48, 12), Color(hex: 0xE23C3C), line: Color(hex: 0x8E1515), width: 3)
            Blob(roundRect(cx - 25, 384, 50, 9, 4.5), Color(hex: 0x8E1515))
            Blob(roundRect(cx - 23, 344, 46, 10, 5), Color(hex: 0xFFE14D))
        }
    }

    private func slipper(_ cx: CGFloat) -> some View {
        ZStack {
            Blob(oval(cx, 382, 58, 28), Color(hex: 0x8FD3FF), line: Color(hex: 0x3A8FD0), width: 3)
            Blob(oval(cx, 372, 22, 18), Color.white, line: Color(hex: 0x3A8FD0), width: 2)
        }
    }
}
