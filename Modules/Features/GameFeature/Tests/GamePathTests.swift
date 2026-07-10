import SharedModels
import Testing
@testable import GameFeature

private let sample = GamePath([
    Coordinate(row: 0, column: 0),
    Coordinate(row: 0, column: 1),
    Coordinate(row: 1, column: 1),
])

@Test func sequenceFromStartKeepsOrder() {
    #expect(sample.sequence(startingAt: Coordinate(row: 0, column: 0)) == sample.coordinates)
}

@Test func sequenceFromEndReversesOrder() {
    let expected = Array(sample.coordinates.reversed())
    #expect(sample.sequence(startingAt: Coordinate(row: 1, column: 1)) == expected)
}

@Test func sequenceFromMiddleIsRejected() {
    #expect(sample.sequence(startingAt: Coordinate(row: 0, column: 1)) == nil)
}

@Test func matchAcceptsBothDirections() {
    #expect(sample.matches(sample.coordinates))
    #expect(sample.matches(Array(sample.coordinates.reversed())))
    #expect(!sample.matches([Coordinate(row: 0, column: 0)]))
}
