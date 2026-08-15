//
//  Style.swift
//  DailyRun
//

import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

extension Font {
    /// Sizes are fixed — they don't scale with Dynamic Type, so the layout
    /// always matches the mockup.
    static func avenir(_ weight: String, _ size: CGFloat) -> Font {
        .custom("AvenirNext-\(weight)", fixedSize: size)
    }
}

enum Palette {
    static let paceTop = Color(hex: 0x070A97)
    static let paceBottom = Color(hex: 0x03045E)
    static let paceBar = Color(hex: 0x4586FF)
    static let paceBarTouched = Color(hex: 0x81AEFF)
    static let paceGrid = Color(hex: 0x2D2FB4)

    static let headToHead = Color(hex: 0x37035E)
    static let headToHeadRow = Color(hex: 0x450079)

    static let paceComparison = Color(hex: 0x035E3C)
    static let paceComparisonBar = Color(hex: 0x00E573)
    static let paceComparisonBarTouched = Color(hex: 0x84FFC2)
    static let paceComparisonAxis = Color(hex: 0x047E51)

    static let trivia = Color(hex: 0x5E2003)
    static let video = Color(hex: 0x5E0303)
    static let learnMore = Color(hex: 0x9D6A43)

    static let paceGradient = LinearGradient(
        colors: [paceTop, paceBottom],
        startPoint: .top,
        endPoint: .bottom
    )
}

extension View {
    /// Full-bleed section: fills the width, pads its content, paints a background.
    func sectionBackground<S: ShapeStyle>(_ style: S) -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(style)
    }
}

/// Icon + title row shared by every component below the header.
struct SectionHeader: View {
    let icon: String
    let text: String
    var font: Font = .avenir("Bold", 16)

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            Text(text)
                .font(font)
                .foregroundStyle(.white)
        }
    }
}

/// Formats seconds as m:ss.
func minuteSecond(_ seconds: Double) -> String {
    let total = Int(seconds.rounded())
    return "\(total / 60):\(String(format: "%02d", total % 60))"
}
