import CoreGraphics
import Testing
@testable import UIComponents

struct GridMetricsTests {
    @Test func cellLengthDividesSideEvenly() {
        let metrics = GridMetrics(dotsPerSide: 4, sideLength: 200)
        #expect(metrics.cellLength == 50)
    }

    @Test func dotDiameterIsCappedOnLargeCells() {
        let metrics = GridMetrics(dotsPerSide: 3, sideLength: 600)
        #expect(metrics.dotDiameter == 30)
    }

    @Test func dotDiameterScalesWithCell() {
        let metrics = GridMetrics(dotsPerSide: 6, sideLength: 300)
        #expect(metrics.dotDiameter == 50 * 0.46)
    }

    @Test func centerOfTopLeftDotIsHalfCell() {
        let metrics = GridMetrics(dotsPerSide: 5, sideLength: 300)
        let center = metrics.center(of: GridPoint(0, 0))
        #expect(center == CGPoint(x: 30, y: 30))
    }

    @Test func centerOfLastDotIsInsideBoard() {
        let metrics = GridMetrics(dotsPerSide: 7, sideLength: 280)
        let center = metrics.center(of: GridPoint(6, 6))
        #expect(center == CGPoint(x: 260, y: 260))
    }
}

struct GridConfigurationTests {
    @Test func fingerWinsOverEveryOtherState() {
        var configuration = GridConfiguration(dotsPerSide: 3)
        let point = GridPoint(1, 1)
        configuration.fingerDot = point
        configuration.wrongDots = [point]
        configuration.correctDots = [point]
        configuration.litDots = [point]
        #expect(configuration.state(of: point) == .finger)
    }

    @Test func statePriorityIsWrongCorrectLitGhost() {
        var configuration = GridConfiguration(dotsPerSide: 3)
        let point = GridPoint(0, 2)
        configuration.ghostDots = [point]
        #expect(configuration.state(of: point) == .ghost)
        configuration.litDots = [point]
        #expect(configuration.state(of: point) == .lit)
        configuration.correctDots = [point]
        #expect(configuration.state(of: point) == .correct)
        configuration.wrongDots = [point]
        #expect(configuration.state(of: point) == .wrong)
    }

    @Test func untouchedDotIsIdle() {
        let configuration = GridConfiguration(dotsPerSide: 3)
        #expect(configuration.state(of: GridPoint(2, 2)) == .idle)
    }
}
