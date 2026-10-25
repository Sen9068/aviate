import CoreGraphics

/// Spacing, radii and sizes shared across the design system.
enum Metrics {
    static let screenPadding: CGFloat = 20
    static let stackSpacing: CGFloat = 16

    static let sheetCornerRadius: CGFloat = 38
    static let cardCornerRadius: CGFloat = 28

    static let controlHeight: CGFloat = 44
    static let buttonHeight: CGFloat = 54
    static let iconButtonSize: CGFloat = 40

    /// Distance from the top safe area to the sheet at its large detent.
    static let sheetLargeTopInset: CGFloat = 8
    /// Sheet top position at its medium detent, as a fraction of the available height.
    static let sheetMediumFraction: CGFloat = 0.42
    /// The sheet can never be dragged lower than this much visible height.
    static let sheetMinVisibleHeight: CGFloat = 160
}
