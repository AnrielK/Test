import SwiftUI

struct QuiltedRoomBackground: View {
    let wallColor: Color
    let lineColor: Color
    let curtainColor: Color

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    // Stěna s kosočtvercovým vzorem
                    ZStack {
                        wallColor
                        Canvas { context, size in
                            let step: CGFloat = 55
                            var path = Path()
                            for x in stride(from: -size.height, through: size.width + size.height, by: step) {
                                path.move(to: CGPoint(x: x, y: 0))
                                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                                path.move(to: CGPoint(x: x, y: size.height))
                                path.addLine(to: CGPoint(x: x + size.height, y: 0))
                            }
                            context.stroke(path, with: .color(lineColor.opacity(0.25)), lineWidth: 3)
                        }
                        Rectangle()
                            .fill(lineColor)
                            .frame(height: 10)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(height: geo.size.height * 0.56)

                    // Dřevěná podlaha
                    WoodFloorView()
                        .frame(height: geo.size.height * 0.44)
                }

                // Závěsy po stranách
                HStack {
                    SideCurtainShape(isLeft: true)
                        .fill(curtainColor)
                        .frame(width: geo.size.width * 0.18)
                    Spacer()
                    SideCurtainShape(isLeft: false)
                        .fill(curtainColor)
                        .frame(width: geo.size.width * 0.18)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct StripedRoomBackground: View {
    let baseColor: Color
    let stripeColor: Color
    var showTopCurtains: Bool = true
    var showKitchenCabinet: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    // Pruhovaná tapeta
                    ZStack(alignment: .topLeading) {
                        baseColor
                        HStack(spacing: 28) {
                            ForEach(0..<22, id: \.self) { _ in
                                Rectangle()
                                    .fill(stripeColor)
                                    .frame(width: 28)
                            }
                        }

                        if showKitchenCabinet {
                            KitchenCabinetView()
                                .offset(x: -10, y: 16)
                        }
                    }
                    .frame(height: geo.size.height * 0.62)

                    // Dřevěná podlaha
                    WoodFloorView(darker: !showKitchenCabinet)
                        .frame(height: geo.size.height * 0.38)
                }

                if showTopCurtains {
                    HStack {
                        Circle()
                            .fill(Color(red: 0.62, green: 0.25, blue: 0.65))
                            .frame(width: 280, height: 280)
                            .offset(x: -95, y: -110)
                        Spacer()
                        Circle()
                            .fill(Color(red: 0.62, green: 0.25, blue: 0.65))
                            .frame(width: 280, height: 280)
                            .offset(x: 95, y: -110)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct KitchenCabinetView: View {
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<2, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(red: 0.95, green: 0.78, blue: 0.58))
                    .frame(width: 82, height: 138)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.86, green: 0.66, blue: 0.46), lineWidth: 3)
                            .padding(10)
                    )
            }
        }
    }
}

struct WoodFloorView: View {
    var darker: Bool = false
    var body: some View {
        LinearGradient(
            colors: darker
                ? [Color(red: 0.58, green: 0.36, blue: 0.24), Color(red: 0.50, green: 0.30, blue: 0.18)]
                : [Color(red: 0.82, green: 0.64, blue: 0.50), Color(red: 0.76, green: 0.56, blue: 0.42)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct SideCurtainShape: Shape {
    let isLeft: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if isLeft {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addQuadCurve(to: CGPoint(x: 0, y: rect.maxY * 0.86), control: CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.55))
            path.closeSubpath()
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.86), control: CGPoint(x: rect.maxX * 0.25, y: rect.maxY * 0.55))
            path.closeSubpath()
        }
        return path
    }
}
