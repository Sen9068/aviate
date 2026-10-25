import SwiftUI

enum SheetDetent: Sendable {
    case medium, large
}

/// Pure layout math for the sheet, kept separate from the view so it can be unit-tested.
enum SheetLayout {
    /// Picks the detent to settle on after a drag. `projectedTop` is where the sheet's top edge
    /// would land using the gesture's *predicted* end translation, so a quick flick snaps even
    /// when the finger only moved a little.
    static func settle(projectedTop: CGFloat, mediumTop: CGFloat, largeTop: CGFloat) -> SheetDetent {
        projectedTop > (mediumTop + largeTop) / 2 ? .medium : .large
    }

    /// Clamps the sheet's top edge while dragging: rubber-band resistance above the large
    /// detent, a hard stop so it can't be pulled below `maxTop`.
    static func constrainedTop(_ proposed: CGFloat, largeTop: CGFloat, maxTop: CGFloat) -> CGFloat {
        if proposed < largeTop {
            return max(0, largeTop - (largeTop - proposed) * 0.2)
        }
        return min(proposed, maxTop)
    }
}

/// The signature Aviate layout: a full-screen backdrop (usually a map) with a dark
/// rounded sheet on top that snaps between medium and large detents.
///
/// Only the grabber + header area drags the sheet; `content` is free to host a ScrollView.
/// A custom sheet is used instead of `.sheet` + `presentationDetents` because a presented
/// sheet would cover the floating tab bar.
struct MapSheetScaffold<Background: View, Header: View, Content: View>: View {
    @Binding private var detent: SheetDetent
    private let background: Background
    private let header: Header
    private let content: Content

    @GestureState(resetTransaction: Transaction(animation: .snappy(duration: 0.35)))
    private var dragTranslation: CGFloat = 0

    @Environment(\.haptics) private var haptics
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(
        detent: Binding<SheetDetent>,
        @ViewBuilder background: () -> Background,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        _detent = detent
        self.background = background()
        self.header = header()
        self.content = content()
    }

    var body: some View {
        GeometryReader { proxy in
            let largeTop = Metrics.sheetLargeTopInset
            let mediumTop = (proxy.size.height * Metrics.sheetMediumFraction).rounded()
            let restingTop = detent == .large ? largeTop : mediumTop
            let top = SheetLayout.constrainedTop(
                restingTop + dragTranslation,
                largeTop: largeTop,
                maxTop: proxy.size.height - Metrics.sheetMinVisibleHeight
            )

            ZStack(alignment: .top) {
                background
                    .ignoresSafeArea()

                sheet(restingTop: restingTop, mediumTop: mediumTop, largeTop: largeTop)
                    .padding(.top, top)
            }
        }
    }

    private func sheet(restingTop: CGFloat, mediumTop: CGFloat, largeTop: CGFloat) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                grabber
                header
            }
            .padding(.bottom, 16)
            .contentShape(.rect)
            .gesture(dragGesture(restingTop: restingTop, mediumTop: mediumTop, largeTop: largeTop))

            content
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            UnevenRoundedRectangle(
                topLeadingRadius: Metrics.sheetCornerRadius,
                topTrailingRadius: Metrics.sheetCornerRadius,
                style: .continuous
            )
            .fill(Palette.sheet)
            .shadow(color: .black.opacity(0.45), radius: 24, y: -4)
        }
        // Extend under the floating tab bar; scroll views inside still inset their content.
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private var grabber: some View {
        Button {
            setDetent(detent == .large ? .medium : .large)
        } label: {
            Capsule()
                .fill(Palette.textSecondary.opacity(0.6))
                .frame(width: 36, height: 5)
                .frame(width: 80, height: 20)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
        .accessibilityLabel("Sheet")
        .accessibilityValue(detent == .large ? Text("Expanded") : Text("Collapsed"))
        .accessibilityHint("Double-tap to resize")
    }

    private func dragGesture(restingTop: CGFloat, mediumTop: CGFloat, largeTop: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .updating($dragTranslation) { value, state, _ in
                state = value.translation.height
            }
            .onEnded { value in
                let projected = restingTop + value.predictedEndTranslation.height
                setDetent(SheetLayout.settle(projectedTop: projected, mediumTop: mediumTop, largeTop: largeTop))
            }
    }

    private func setDetent(_ newDetent: SheetDetent) {
        if newDetent != detent { haptics.tap(.soft) }
        withAnimation(reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.4, dampingFraction: 0.85)) {
            detent = newDetent
        }
    }
}
