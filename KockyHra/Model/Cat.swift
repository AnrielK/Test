import SwiftUI

enum CatType: String, CaseIterable, Identifiable {
    case ginger // Levá kočička (zrzavobílá)
    case spotted // Prostřední kočička (hnědobílá)
    case grey // Pravá kočička (šedá)

    var id: String { rawValue }

    var name: String {
        switch self {
        case .ginger: return "Míca"
        case .spotted: return "Flek"
        case .grey: return "Tlapka"
        }
    }

    var primaryColor: Color {
        switch self {
        case .ginger: return Color(red: 0.93, green: 0.53, blue: 0.20)
        case .spotted: return Color(red: 0.45, green: 0.25, blue: 0.18)
        case .grey: return Color(red: 0.38, green: 0.43, blue: 0.52)
        }
    }

    var eyeColor: Color {
        switch self {
        case .ginger: return Color(red: 0.08, green: 0.45, blue: 0.82)
        case .spotted: return Color(red: 0.18, green: 0.65, blue: 0.92)
        case .grey: return Color(red: 0.45, green: 0.68, blue: 0.28)
        }
    }

    var bowColor: Color {
        switch self {
        case .ginger: return Color(red: 0.25, green: 0.52, blue: 0.96)
        case .spotted: return Color(red: 0.35, green: 0.78, blue: 0.98)
        case .grey: return Color(red: 0.40, green: 0.85, blue: 0.35)
        }
    }
}

enum FoodType: String, CaseIterable, Identifiable {
    case chicken, steak, sausage, salmon, cheese, fish
    var id: String { rawValue }
}
