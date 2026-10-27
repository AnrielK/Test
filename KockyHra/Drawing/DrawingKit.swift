import SwiftUI

struct SparkleView: View {
    var size: CGFloat = 14

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.45, height: size * 0.45)
                .blur(radius: 1)
            Image(systemName: "sparkle")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(.white)
        }
    }
}

struct ScallopedOvalCarpet: View {
    var mainColor: Color = Color(red: 0.62, green: 0.32, blue: 0.92)

    var body: some View {
        ZStack {
            // Krajkový bílý okraj
            ForEach(0..<18, id: \.self) { i in
                let angle = Double(i) * (360.0 / 18.0) * .pi / 180.0
                Circle()
                    .fill(Color.white)
                    .frame(width: 44, height: 32)
                    .offset(x: CGFloat(cos(angle)) * 118, y: CGFloat(sin(angle)) * 62)
            }
            Ellipse()
                .fill(Color.white)
                .frame(width: 246, height: 132)

            Ellipse()
                .fill(mainColor)
                .frame(width: 222, height: 112)

            Ellipse()
                .stroke(Color.white.opacity(0.25), lineWidth: 5)
                .frame(width: 185, height: 86)
        }
    }
}

struct StagePodium: View {
    var body: some View {
        ZStack {
            // Zlatý 3D podstavec
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.90, green: 0.72, blue: 0.22), Color(red: 0.98, green: 0.84, blue: 0.32)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 205, height: 88)
                .offset(y: 12)

            // Horní zlatý lem
            Ellipse()
                .fill(Color(red: 0.98, green: 0.86, blue: 0.35))
                .frame(width: 205, height: 82)

            // Růžový vnitřek
            Ellipse()
                .fill(Color(red: 0.95, green: 0.38, blue: 0.72))
                .frame(width: 176, height: 66)

            // Stín pod kočičkou
            Ellipse()
                .fill(Color(red: 0.84, green: 0.28, blue: 0.60))
                .frame(width: 116, height: 40)
        }
    }
}
