import SwiftUI

enum OutfitCategory: String, CaseIterable, Identifiable {
    case hats
    case tops
    case bottoms
    case shoes
    case glasses

    var id: String { rawValue }
}

enum HatType: String, CaseIterable, Identifiable {
    case tangerineBeret // Oranžový baret s lístky
    case heartHeadband  // Čelenka se srdíčky
    case sunHat         // Fialový klobouk s květinou
    case flowerCrown    // Květinová čelenka
    case goldCrown      // Zlatá koruna
    case policeCap      // Policejní čepice

    var id: String { rawValue }
}

enum TopType: String, CaseIterable, Identifiable {
    case policeJacket, pinkShirt, stripedSweater, superheroCape
    var id: String { rawValue }
}

enum BottomType: String, CaseIterable, Identifiable {
    case blueShorts, pinkSkirt, denimJeans, overalls
    var id: String { rawValue }
}

enum ShoeType: String, CaseIterable, Identifiable {
    case blackSneakers, pinkBowShoes, yellowBoots, redRunners
    var id: String { rawValue }
}

enum GlassesType: String, CaseIterable, Identifiable {
    case brownAviators, starGlasses, heartGlasses, roundFrames
    var id: String { rawValue }
}

struct CatOutfit: Equatable {
    var hat: HatType? = nil
    var top: TopType? = nil
    var bottom: BottomType? = nil
    var shoes: ShoeType? = nil
    var glasses: GlassesType? = nil

    static let policePreset = CatOutfit(
        hat: .policeCap,
        top: .policeJacket,
        bottom: nil,
        shoes: .blackSneakers,
        glasses: .brownAviators
    )
}
