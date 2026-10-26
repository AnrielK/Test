import SwiftUI

enum CatPattern {
    /// Mourek – proužky na čele a tvářích.
    case tabby
    /// Zrzek – bílý čumáček a lysinka mezi očima.
    case blaze
    /// Micka – hnědé skvrny.
    case patches
}

struct Cat: Identifiable, Hashable {
    let id: Int
    let name: String
    let fur: Color
    let furLight: Color
    let bodyFur: Color
    let belly: Color
    let paw: Color
    let dark: Color
    let patch: Color
    let eye: Color
    let eyeLight: Color
    let bell: Color
    let pattern: CatPattern

    static let all: [Cat] = [
        Cat(id: 0, name: "Zrzek",
            fur: Color(hex: 0xF39A4A), furLight: Color(hex: 0xFFC583),
            bodyFur: Color(hex: 0xEE8C3B), belly: .white, paw: .white,
            dark: Color(hex: 0x9A4A1C), patch: .clear,
            eye: Color(hex: 0x8A5410), eyeLight: Color(hex: 0xF2B544),
            bell: Color(hex: 0x3F7BE0), pattern: .blaze),
        Cat(id: 1, name: "Micka",
            fur: Color(hex: 0xFFF4EC), furLight: .white,
            bodyFur: Color(hex: 0x7C4731), belly: .white, paw: .white,
            dark: Color(hex: 0x5A3322), patch: Color(hex: 0x8B5236),
            eye: Color(hex: 0x1F5FD6), eyeLight: Color(hex: 0x95CCFF),
            bell: Color(hex: 0x4FA8F0), pattern: .patches),
        Cat(id: 2, name: "Mourek",
            fur: Color(hex: 0x6F7CA3), furLight: Color(hex: 0x9EA9CB),
            bodyFur: Color(hex: 0x5E6A92), belly: Color(hex: 0xF1F2F8), paw: .white,
            dark: Color(hex: 0x2C3560), patch: Color(hex: 0x2C3560),
            eye: Color(hex: 0x23902F), eyeLight: Color(hex: 0xA8F07C),
            bell: Color(hex: 0x3FCB5A), pattern: .tabby),
    ]
}
