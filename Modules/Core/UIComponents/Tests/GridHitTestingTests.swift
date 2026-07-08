import CoreGraphics
import Testing
@testable import UIComponents

struct GridHitTestingTests {
    private let metrics = GridMetrics(dotsPerSide: 5, sideLength: 100) // cellLength 20

    @Test func pointMapsToItsCell() {
        #expect(metrics.coordinate(at: CGPoint(x: 10, y: 10)) == GridPoint(0, 0))
        #expect(metrics.coordinate(at: CGPoint(x: 50, y: 30)) == GridPoint(1, 2))
        #expect(metrics.coordinate(at: CGPoint(x: 99, y: 99)) == GridPoint(4, 4))
    }

    @Test func centerRoundTripsBackToTheSameCell() {
        let cell = GridPoint(3, 1)
        #expect(metrics.coordinate(at: metrics.center(of: cell)) == cell)
    }

    @Test func pointOutsideTheBoardIsNil() {
        #expect(metrics.coordinate(at: CGPoint(x: -1, y: 10)) == nil)
        #expect(metrics.coordinate(at: CGPoint(x: 10, y: 120)) == nil)
    }
}
