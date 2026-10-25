import CoreGraphics
import Testing
@testable import Aviate

struct PaletteTests {
    @Test func parsesHexComponents() {
        let rgb = RGB(hex: 0x3B82F6)
        #expect(rgb == RGB(hex: 0x3B82F6))
        #expect(rgb.red == 59.0 / 255)
        #expect(rgb.green == 130.0 / 255)
        #expect(rgb.blue == 246.0 / 255)
    }

    @Test func parsesBlackAndWhite() {
        #expect(RGB(hex: 0x000000).red == 0)
        #expect(RGB(hex: 0xFFFFFF).blue == 1)
    }
}

struct SheetLayoutTests {
    let mediumTop: CGFloat = 400
    let largeTop: CGFloat = 8

    @Test func smallDragStaysMedium() {
        #expect(SheetLayout.settle(projectedTop: 360, mediumTop: mediumTop, largeTop: largeTop) == .medium)
    }

    @Test func dragPastMidpointSnapsLarge() {
        #expect(SheetLayout.settle(projectedTop: 150, mediumTop: mediumTop, largeTop: largeTop) == .large)
    }

    @Test func flickDownFromLargeSnapsMedium() {
        #expect(SheetLayout.settle(projectedTop: 500, mediumTop: mediumTop, largeTop: largeTop) == .medium)
    }

    @Test func rubberBandsAboveLargeDetent() {
        let top = SheetLayout.constrainedTop(-92, largeTop: largeTop, maxTop: 600)
        #expect(top == 0)  // 8 - 100 * 0.2 = -12, clamped to 0

        let gentle = SheetLayout.constrainedTop(-2, largeTop: largeTop, maxTop: 600)
        #expect(gentle == 6)  // 8 - 10 * 0.2
    }

    @Test func clampsBelowMinimumVisibleHeight() {
        #expect(SheetLayout.constrainedTop(900, largeTop: largeTop, maxTop: 600) == 600)
    }
}
