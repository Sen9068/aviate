import SwiftUI

/// Aviate's color tokens. The app is dark-first; a light palette can be added later
/// by turning these into asset-catalog colors with light/dark variants.
enum Palette {
    static let sheet = Color(hex: 0x1E1F24)
    static let card = Color(hex: 0x2A2B30)
    static let divider = Color(hex: 0x3A3B40)

    static let textPrimary = Color.white
    static let textSecondary = Color(hex: 0x8E8E93)

    static let accent = Color(hex: 0x3B82F6)
    static let success = Color(hex: 0x34C759)
    static let warning = Color(hex: 0xFF9F0A)
    static let error = Color(hex: 0xFF453A)
    static let xpGold = Color(hex: 0xFFD60A)
}

/// sRGB components parsed from a 24-bit hex literal such as `0x3B82F6`.
struct RGB: Equatable, Sendable {
    let red: Double
    let green: Double
    let blue: Double

    init(hex: UInt32) {
        red = Double((hex >> 16) & 0xFF) / 255
        green = Double((hex >> 8) & 0xFF) / 255
        blue = Double(hex & 0xFF) / 255
    }
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        let rgb = RGB(hex: hex)
        self.init(.sRGB, red: rgb.red, green: rgb.green, blue: rgb.blue, opacity: opacity)
    }
}
