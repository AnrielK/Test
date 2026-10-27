import SwiftUI

struct ScratchingPostView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 0.42, green: 0.22, blue: 0.08))
                .frame(width: 58, height: 220)
                .cornerRadius(8)

            VStack(spacing: 3) {
                ForEach(0..<6, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.90, green: 0.80, blue: 0.56))
                        .frame(width: 68, height: 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 0.76, green: 0.64, blue: 0.40), lineWidth: 1.5)
                        )
                }
            }
            .offset(y: 16)
        }
    }
}

struct YarnBallView: View {
    let color: Color
    var size: CGFloat = 70

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
            Circle()
                .stroke(Color.black.opacity(0.18), lineWidth: 3)
                .frame(width: size * 0.8, height: size * 0.5)
                .rotationEffect(.degrees(30))
            Circle()
                .stroke(Color.black.opacity(0.18), lineWidth: 3)
                .frame(width: size * 0.8, height: size * 0.5)
                .rotationEffect(.degrees(-35))
        }
    }
}

struct ToyMouseView: View {
    var body: some View {
        ZStack {
            // Černý ocásek
            Capsule()
                .fill(Color.black)
                .frame(width: 36, height: 3)
                .offset(x: -36, y: 8)

            // Modré tělíčko
            Ellipse()
                .fill(Color(red: 0.35, green: 0.68, blue: 0.98))
                .frame(width: 58, height: 36)

            // Flíčky a ouško
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 12, height: 12)
                .offset(x: -6, y: -4)
            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 16, height: 16)
                .offset(x: 10, y: -12)
            Circle()
                .fill(Color.black)
                .frame(width: 5, height: 5)
                .offset(x: 20, y: 2)
        }
    }
}

struct ThoughtBubbleFoodView: View {
    let food: FoodType

    var body: some View {
        ZStack {
            // Malé kroužky bubliny
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
                .offset(x: -24, y: 54)
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .offset(x: -12, y: 40)

            // Hlavní obláček
            ZStack {
                Circle().fill(Color.white).frame(width: 68, height: 68).offset(x: -22, y: 0)
                Circle().fill(Color.white).frame(width: 68, height: 68).offset(x: 22, y: 0)
                Circle().fill(Color.white).frame(width: 74, height: 74).offset(x: 0, y: -14)
                Capsule().fill(Color.white).frame(width: 104, height: 58).offset(y: 10)
            }

            FoodIconView(food: food, size: 54)
        }
    }
}

struct FoodIconView: View {
    let food: FoodType
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            switch food {
            case .chicken:
                ZStack {
                    Ellipse()
                        .fill(LinearGradient(colors: [.orange, Color(red: 0.80, green: 0.42, blue: 0.12)], startPoint: .top, endPoint: .bottom))
                        .frame(width: size, height: size * 0.68)
                    Capsule()
                        .fill(Color.white)
                        .frame(width: size * 0.35, height: 8)
                        .rotationEffect(.degrees(35))
                        .offset(x: -size * 0.32, y: -size * 0.22)
                }
            case .steak:
                ZStack {
                    Ellipse()
                        .fill(Color(red: 0.85, green: 0.25, blue: 0.22))
                        .frame(width: size, height: size * 0.66)
                    Ellipse()
                        .stroke(Color(red: 0.98, green: 0.86, blue: 0.82), lineWidth: 4)
                        .frame(width: size * 0.78, height: size * 0.44)
                }
            case .sausage:
                Capsule()
                    .fill(Color(red: 0.86, green: 0.35, blue: 0.14))
                    .frame(width: size, height: size * 0.38)
            case .salmon:
                ZStack {
                    Ellipse()
                        .fill(Color(red: 0.28, green: 0.32, blue: 0.48))
                        .frame(width: size, height: size * 0.62)
                        .offset(y: 5)
                    Ellipse()
                        .fill(Color(red: 0.96, green: 0.48, blue: 0.28))
                        .frame(width: size, height: size * 0.58)
                    Ellipse()
                        .stroke(Color.white.opacity(0.75), lineWidth: 2.5)
                        .frame(width: size * 0.65, height: size * 0.34)
                }
            case .cheese:
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow)
                        .frame(width: size * 0.9, height: size * 0.58)
                    Circle().fill(Color.orange.opacity(0.6)).frame(width: 9, height: 9).offset(x: -10, y: 2)
                    Circle().fill(Color.orange.opacity(0.6)).frame(width: 7, height: 7).offset(x: 10, y: -4)
                }
            case .fish:
                HStack(spacing: -6) {
                    Ellipse()
                        .fill(Color(red: 0.55, green: 0.62, blue: 0.78))
                        .frame(width: size * 0.82, height: size * 0.46)
                        .overlay(
                            Text("×")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .offset(x: -size * 0.22)
                        )
                    Image(systemName: "play.fill")
                        .rotationEffect(.degrees(180))
                        .foregroundColor(Color(red: 0.45, green: 0.52, blue: 0.68))
                }
            }
        }
    }
}
