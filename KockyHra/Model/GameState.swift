import SwiftUI

enum Screen {
    case menu
    case selectCat
    case dressUp
    case feeding
    case grooming
    case litter
}

class GameState: ObservableObject {
    @Published var currentScreen: Screen = .menu
    @Published var selectedCat: CatType = .ginger

    @Published var outfits: [CatType: CatOutfit] = [
        .ginger: CatOutfit(),
        .spotted: CatOutfit(),
        .grey: CatOutfit.policePreset
    ]

    @Published var hungerProgress: Double = 0.75
    @Published var desiredFood: FoodType = .salmon
    @Published var groomingProgress: Double = 0.35
    @Published var litterProgress: Double = 0.25

    var currentOutfit: CatOutfit {
        get { outfits[selectedCat] ?? CatOutfit() }
        set { outfits[selectedCat] = newValue }
    }

    func selectCat(_ cat: CatType) {
        selectedCat = cat
        currentScreen = .dressUp
    }

    func randomizeCraving() {
        desiredFood = FoodType.allCases.randomElement() ?? .salmon
    }
}
