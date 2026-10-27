import SwiftUI

struct CatView: View {
    let catType: CatType
    var outfit: CatOutfit = CatOutfit()
    var isWaving: Bool = false
    var showLowerBody: Bool = true

    var body: some View {
        ZStack {
            // Mašle za krkem
            NeckBowView(color: catType.bowColor)
                .offset(y: 34)

            if showLowerBody {
                // Ocas
                CatTailView(catType: catType)
                    .offset(x: -44, y: 82)

                // Tělo a tlapky
                CatBodyView(catType: catType, outfit: outfit, isWaving: isWaving)
                    .offset(y: 66)
            }

            // Hlava kočičky
            CatHeadView(catType: catType, outfit: outfit)
                .offset(y: -22)
        }
        .frame(width: 220, height: 260)
    }
}

struct NeckBowView: View {
    let color: Color
    var body: some View {
        HStack(spacing: 36) {
            Ellipse()
                .fill(color)
                .frame(width: 44, height: 28)
                .rotationEffect(.degrees(-20))
            Ellipse()
                .fill(color)
                .frame(width: 44, height: 28)
                .rotationEffect(.degrees(20))
        }
    }
}

struct CatTailView: View {
    let catType: CatType
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(catType.primaryColor)
                .frame(width: 54, height: 18)
                .rotationEffect(.degrees(25))
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .offset(x: -4, y: -10)
        }
    }
}

struct CatBodyView: View {
    let catType: CatType
    let outfit: CatOutfit
    let isWaving: Bool

    var body: some View {
        ZStack {
            // Ručičky
            HStack(spacing: 74) {
                CatArmView(color: catType.primaryColor)
                    .rotationEffect(.degrees(28))
                CatArmView(color: catType.primaryColor)
                    .rotationEffect(.degrees(isWaving ? -115 : -28))
                    .offset(y: isWaving ? -16 : 0)
            }
            .offset(y: -8)

            // Trup
            RoundedRectangle(cornerRadius: 34)
                .fill(catType.primaryColor)
                .frame(width: 78, height: 84)

            // Bílé bříško
            Ellipse()
                .fill(Color.white)
                .frame(width: 50, height: 64)
                .offset(y: 4)

            // Nožičky / Boty
            HStack(spacing: 18) {
                CatFootView(shoe: outfit.shoes)
                CatFootView(shoe: outfit.shoes)
            }
            .offset(y: 40)

            // Kalhoty / sukně
            if let bottom = outfit.bottom {
                BottomClothingView(bottom: bottom)
                    .offset(y: 20)
            }

            // Tričko / bunda
            if let top = outfit.top {
                TopClothingView(top: top)
                    .offset(y: -2)
            }

            // Obojek a rolnička
            VStack(spacing: -2) {
                Capsule()
                    .fill(Color.black)
                    .frame(width: 68, height: 7)
                ZStack {
                    Circle()
                        .fill(catType == .grey ? Color.green : Color(red: 0.25, green: 0.58, blue: 0.98))
                        .frame(width: 24, height: 24)
                    Circle()
                        .fill(Color.black.opacity(0.75))
                        .frame(width: 6, height: 6)
                        .offset(y: 2)
                }
            }
            .offset(y: -30)
        }
    }
}

struct CatArmView: View {
    let color: Color
    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(color)
                .frame(width: 22, height: 52)
            Circle()
                .fill(Color.white)
                .frame(width: 22, height: 20)
            // Polštářky tlapek
            Circle()
                .fill(color.opacity(0.8))
                .frame(width: 7, height: 7)
                .offset(y: -4)
        }
    }
}

struct CatFootView: View {
    let shoe: ShoeType?
    var body: some View {
        if let shoe = shoe {
            switch shoe {
            case .blackSneakers:
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .frame(width: 28, height: 20)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 28, height: 5)
                        .offset(y: 6)
                    Text("⋈")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: -2)
                }
            case .pinkBowShoes:
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.pink)
                        .frame(width: 28, height: 18)
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 8, height: 8)
                        .offset(y: -5)
                }
            case .yellowBoots:
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.yellow)
                    .frame(width: 28, height: 22)
            case .redRunners:
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red)
                    .frame(width: 28, height: 18)
            }
        } else {
            ZStack {
                Capsule()
                    .fill(Color.white)
                    .frame(width: 24, height: 14)
                HStack(spacing: 3) {
                    Circle().fill(Color.gray.opacity(0.35)).frame(width: 4, height: 4)
                    Circle().fill(Color.gray.opacity(0.35)).frame(width: 4, height: 4)
                }
            }
        }
    }
}

struct TopClothingView: View {
    let top: TopType
    var body: some View {
        switch top {
        case .policeJacket:
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.14, green: 0.14, blue: 0.16))
                    .frame(width: 80, height: 56)
                VStack(spacing: 7) {
                    Circle().fill(Color.gray).frame(width: 5, height: 5)
                    Circle().fill(Color.gray).frame(width: 5, height: 5)
                }
                .offset(y: 6)
            }
        case .pinkShirt:
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pink)
                .frame(width: 78, height: 50)
        case .stripedSweater:
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange)
                .frame(width: 78, height: 52)
        case .superheroCape:
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red)
                .frame(width: 82, height: 54)
        }
    }
}

struct BottomClothingView: View {
    let bottom: BottomType
    var body: some View {
        switch bottom {
        case .blueShorts:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .frame(width: 74, height: 28)
        case .pinkSkirt:
            Capsule()
                .fill(Color.pink.opacity(0.9))
                .frame(width: 84, height: 26)
        case .denimJeans:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.indigo)
                .frame(width: 74, height: 30)
        case .overalls:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cyan)
                .frame(width: 76, height: 34)
        }
    }
}

struct CatHeadView: View {
    let catType: CatType
    let outfit: CatOutfit

    var body: some View {
        ZStack {
            // Uši
            HStack(spacing: 68) {
                CatEarView(outerColor: catType == .spotted ? Color(red: 0.18, green: 0.16, blue: 0.16) : catType.primaryColor)
                    .rotationEffect(.degrees(-18))
                CatEarView(outerColor: catType == .spotted ? Color(red: 0.18, green: 0.16, blue: 0.16) : catType.primaryColor)
                    .rotationEffect(.degrees(18))
            }
            .offset(y: -48)

            // Základ hlavy
            Ellipse()
                .fill(catType == .spotted ? Color.white : catType.primaryColor)
                .frame(width: 166, height: 132)

            // Zbarvení obličeje podle typu kočičky
            if catType == .ginger {
                // Bílý pruh přes čelo a čumáček
                Capsule()
                    .fill(Color.white)
                    .frame(width: 54, height: 118)
                    .offset(y: 6)
                Ellipse()
                    .fill(Color.white)
                    .frame(width: 136, height: 58)
                    .offset(y: 36)
            } else if catType == .spotted {
                // Hnědé flíčky kolem očí a srdíčko na tváři
                Ellipse()
                    .fill(catType.primaryColor)
                    .frame(width: 72, height: 68)
                    .rotationEffect(.degrees(-20))
                    .offset(x: -38, y: -6)
                Ellipse()
                    .fill(catType.primaryColor)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(18))
                    .offset(x: 38, y: 0)
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(catType.primaryColor)
                    .rotationEffect(.degrees(-25))
                    .offset(x: 48, y: 36)
            } else if catType == .grey {
                Ellipse()
                    .fill(Color.white.opacity(0.28))
                    .frame(width: 120, height: 54)
                    .offset(y: 34)
            }

            // Růžové tvářičky
            HStack(spacing: 82) {
                Ellipse().fill(Color.pink.opacity(0.35)).frame(width: 28, height: 16)
                Ellipse().fill(Color.pink.opacity(0.35)).frame(width: 28, height: 16)
            }
            .offset(y: 22)

            // Obočí
            HStack(spacing: 48) {
                Capsule()
                    .fill(Color(red: 0.35, green: 0.18, blue: 0.08))
                    .frame(width: 18, height: 9)
                    .rotationEffect(.degrees(-16))
                Capsule()
                    .fill(Color(red: 0.35, green: 0.18, blue: 0.08))
                    .frame(width: 18, height: 9)
                    .rotationEffect(.degrees(16))
            }
            .offset(y: -34)

            // Velké třpytivé oči
            HStack(spacing: 18) {
                CatEyeView(irisColor: catType.eyeColor)
                CatEyeView(irisColor: catType.eyeColor)
            }
            .offset(y: 0)

            // Čumáček a tlamička
            VStack(spacing: 1) {
                Ellipse()
                    .fill(Color(red: 0.95, green: 0.38, blue: 0.52))
                    .frame(width: 14, height: 10)
                CatMouthShape()
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: 26, height: 10)
            }
            .offset(y: 26)

            // Vousky
            HStack(spacing: 118) {
                WhiskersView(isLeft: true)
                WhiskersView(isLeft: false)
            }
            .offset(y: 22)

            // Brýle
            if let glasses = outfit.glasses {
                GlassesOverlayView(glasses: glasses)
                    .offset(y: -2)
            }

            // Čepice / Klobouk
            if let hat = outfit.hat {
                HatOverlayView(hat: hat)
                    .offset(y: -66)
            }
        }
    }
}

struct CatEarView: View {
    let outerColor: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(outerColor)
                .frame(width: 52, height: 58)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.98, green: 0.76, blue: 0.80))
                .frame(width: 32, height: 38)
        }
    }
}

struct CatEyeView: View {
    let irisColor: Color
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 54, height: 54)
                .overlay(Circle().stroke(Color.black, lineWidth: 2.5))

            Circle()
                .fill(
                    RadialGradient(
                        colors: [irisColor.opacity(0.8), irisColor, Color.black],
                        center: .center,
                        startRadius: 4,
                        endRadius: 24
                    )
                )
                .frame(width: 44, height: 44)

            Circle()
                .fill(Color.black)
                .frame(width: 28, height: 28)

            // Odlesky v očích
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .offset(x: -8, y: -8)
            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: 6, height: 6)
                .offset(x: 8, y: 8)
        }
    }
}

struct CatMouthShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 2))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: 2), control: CGPoint(x: rect.width * 0.25, y: rect.height))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: 2), control: CGPoint(x: rect.width * 0.75, y: rect.height))
        return path
    }
}

struct WhiskersView: View {
    let isLeft: Bool
    var body: some View {
        VStack(spacing: 7) {
            Capsule().fill(Color.black.opacity(0.8)).frame(width: 28, height: 2)
                .rotationEffect(.degrees(isLeft ? 10 : -10))
            Capsule().fill(Color.black.opacity(0.8)).frame(width: 30, height: 2)
            Capsule().fill(Color.black.opacity(0.8)).frame(width: 28, height: 2)
                .rotationEffect(.degrees(isLeft ? -10 : 10))
        }
    }
}

struct GlassesOverlayView: View {
    let glasses: GlassesType
    var body: some View {
        switch glasses {
        case .brownAviators:
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brown.opacity(0.55))
                    .frame(width: 68, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.38, green: 0.20, blue: 0.10), lineWidth: 4))
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brown.opacity(0.55))
                    .frame(width: 68, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.38, green: 0.20, blue: 0.10), lineWidth: 4))
            }
            .overlay(Rectangle().fill(Color(red: 0.38, green: 0.20, blue: 0.10)).frame(width: 14, height: 5))
        case .starGlasses:
            HStack(spacing: 14) {
                Image(systemName: "star.fill").font(.system(size: 50)).foregroundColor(.pink.opacity(0.75))
                Image(systemName: "star.fill").font(.system(size: 50)).foregroundColor(.pink.opacity(0.75))
            }
        case .heartGlasses:
            HStack(spacing: 14) {
                Image(systemName: "heart.fill").font(.system(size: 48)).foregroundColor(.red.opacity(0.75))
                Image(systemName: "heart.fill").font(.system(size: 48)).foregroundColor(.red.opacity(0.75))
            }
        case .roundFrames:
            HStack(spacing: 12) {
                Circle().stroke(Color.purple, lineWidth: 4).frame(width: 58, height: 58)
                Circle().stroke(Color.purple, lineWidth: 4).frame(width: 58, height: 58)
            }
        }
    }
}

struct HatOverlayView: View {
    let hat: HatType
    var body: some View {
        switch hat {
        case .tangerineBeret:
            ZStack {
                Capsule()
                    .fill(Color.orange)
                    .frame(width: 78, height: 36)
                HStack(spacing: 2) {
                    Ellipse().fill(Color.green).frame(width: 18, height: 10).rotationEffect(.degrees(-25))
                    Ellipse().fill(Color.green).frame(width: 22, height: 12).rotationEffect(.degrees(20))
                }
                .offset(y: -20)
            }
        case .heartHeadband:
            ZStack {
                Capsule()
                    .fill(Color.black)
                    .frame(width: 96, height: 10)
                    .offset(y: 12)
                HStack(spacing: 42) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Circle().fill(Color.black))
                    Image(systemName: "heart.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Circle().fill(Color.black))
                }
                .offset(y: -8)
            }
        case .sunHat:
            ZStack {
                Capsule().fill(Color.purple.opacity(0.75)).frame(width: 118, height: 22).offset(y: 10)
                RoundedRectangle(cornerRadius: 16).fill(Color.purple.opacity(0.85)).frame(width: 68, height: 30)
                Circle().fill(Color.yellow).frame(width: 14, height: 14).offset(x: 16, y: 2)
            }
        case .flowerCrown:
            HStack(spacing: -4) {
                ForEach(0..<5, id: \.self) { _ in
                    ZStack {
                        Image(systemName: "seal.fill").font(.system(size: 24)).foregroundColor(.yellow)
                        Circle().fill(Color.orange).frame(width: 8, height: 8)
                    }
                }
            }
            .offset(y: 10)
        case .goldCrown:
            ZStack {
                Image(systemName: "crown.fill")
                    .font(.system(size: 46))
                    .foregroundColor(.yellow)
                    .shadow(color: .orange, radius: 1)
            }
        case .policeCap:
            ZStack {
                Capsule()
                    .fill(Color(red: 0.10, green: 0.10, blue: 0.12))
                    .frame(width: 108, height: 48)
                Capsule()
                    .fill(Color.black)
                    .frame(width: 86, height: 16)
                    .offset(y: 18)
                Image(systemName: "pentagon.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(180))
                    .offset(y: -2)
            }
        }
    }
}
