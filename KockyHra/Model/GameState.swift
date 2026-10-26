import SwiftUI
import Observation

enum Screen: Hashable {
    case select, menu, dressUp, feeding, litter, grooming
}

@Observable
final class GameState {
    var screen: Screen = .select
    private(set) var catID = 0
    private(set) var outfits: [Int: Outfit] = [:]
    private(set) var stars = 0

    private let defaults = UserDefaults.standard

    init() {
        catID = defaults.integer(forKey: "catID")
        stars = defaults.integer(forKey: "stars")
        if let data = defaults.data(forKey: "outfits"),
           let saved = try? JSONDecoder().decode([Int: Outfit].self, from: data) {
            outfits = saved
        }
    }

    var cat: Cat { Cat.all.first { $0.id == catID } ?? Cat.all[0] }

    var outfit: Outfit {
        get { outfits[catID] ?? Outfit() }
        set {
            outfits[catID] = newValue
            if let data = try? JSONEncoder().encode(outfits) {
                defaults.set(data, forKey: "outfits")
            }
        }
    }

    func choose(_ cat: Cat) {
        catID = cat.id
        defaults.set(catID, forKey: "catID")
    }

    func completeGame() {
        stars += 1
        defaults.set(stars, forKey: "stars")
    }

    func go(_ screen: Screen) {
        withAnimation(.easeInOut(duration: 0.35)) { self.screen = screen }
    }
}
