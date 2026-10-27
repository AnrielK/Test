import SwiftUI

struct TopCircleButton: View {
    let systemIcon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.32, green: 0.72, blue: 0.98), Color(red: 0.14, green: 0.52, blue: 0.94)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 46, height: 46)
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(color: .black.opacity(0.2), radius: 3, y: 2)

                Image(systemName: systemIcon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

struct HangingCheckButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: -6) {
                // Růžový závěsný popruh
                Rectangle()
                    .fill(Color(red: 0.86, green: 0.32, blue: 0.68))
                    .frame(width: 14, height: 74)
                    .overlay(Rectangle().stroke(Color.white, lineWidth: 2))

                // Zelené kulaté tlačítko s fajfkou
                ZStack {
                    Circle()
                        .fill(Color(red: 0.92, green: 0.42, blue: 0.72))
                        .frame(width: 78, height: 78)
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.55, green: 0.92, blue: 0.25), Color(red: 0.35, green: 0.78, blue: 0.18)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 66, height: 66)

                    Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct ThermometerProgressBar: View {
    let progress: Double // 0.0 až 1.0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Trubice teploměru
            VStack(spacing: -14) {
                ZStack(alignment: .bottom) {
                    Capsule()
                        .fill(Color(red: 0.12, green: 0.38, blue: 0.78))
                        .frame(width: 36, height: 210)
                        .overlay(Capsule().stroke(Color.white, lineWidth: 4))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.35, green: 0.78, blue: 1.0), Color(red: 0.18, green: 0.56, blue: 0.96)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 26, height: max(26, CGFloat(progress) * 198))
                        .padding(.bottom, 6)
                }

                // Spodní baňka
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(red: 0.48, green: 0.88, blue: 1.0), Color(red: 0.16, green: 0.58, blue: 0.98)],
                            center: .topLeading,
                            startRadius: 4,
                            endRadius: 34
                        )
                    )
                    .frame(width: 58, height: 58)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            }
        }
    }
}

struct BigPlayButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.28, green: 0.72, blue: 1.0), Color(red: 0.12, green: 0.48, blue: 0.96)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 156, height: 156)
                    .overlay(Circle().stroke(Color.white, lineWidth: 6))
                    .shadow(color: .black.opacity(0.25), radius: 6, y: 4)

                // Odlesk
                Ellipse()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 44, height: 22)
                    .rotationEffect(.degrees(-35))
                    .offset(x: -36, y: -38)

                Image(systemName: "play.fill")
                    .font(.system(size: 70, weight: .black))
                    .foregroundColor(.white)
                    .offset(x: 6)
            }
        }
        .buttonStyle(.plain)
    }
}
