import SwiftUI

/// Named text styles from the Aviate spec. Each one has a fixed design size and scales with
/// Dynamic Type relative to the closest system text style.
enum AviateTextStyle {
    /// 22pt semibold, centered screen titles.
    case screenTitle
    /// 28pt regular, large blue list actions ("Continue lesson").
    case largeAction
    /// 24pt semibold, gray section headers ("History").
    case sectionHeader
    /// 17pt regular, secondary helper text.
    case helper
    /// 13pt semibold, small captions and chips.
    case caption

    fileprivate var size: CGFloat {
        switch self {
        case .screenTitle: 22
        case .largeAction: 28
        case .sectionHeader: 24
        case .helper: 17
        case .caption: 13
        }
    }

    fileprivate var weight: Font.Weight {
        switch self {
        case .screenTitle, .sectionHeader, .caption: .semibold
        case .largeAction, .helper: .regular
        }
    }

    fileprivate var relativeTo: Font.TextStyle {
        switch self {
        case .screenTitle, .sectionHeader: .title2
        case .largeAction: .title
        case .helper: .body
        case .caption: .footnote
        }
    }
}

private struct AviateFontModifier: ViewModifier {
    @ScaledMetric private var size: CGFloat
    private let weight: Font.Weight

    init(style: AviateTextStyle) {
        _size = ScaledMetric(wrappedValue: style.size, relativeTo: style.relativeTo)
        weight = style.weight
    }

    func body(content: Content) -> some View {
        content.font(.system(size: size, weight: weight))
    }
}

extension View {
    func textStyle(_ style: AviateTextStyle) -> some View {
        modifier(AviateFontModifier(style: style))
    }
}
