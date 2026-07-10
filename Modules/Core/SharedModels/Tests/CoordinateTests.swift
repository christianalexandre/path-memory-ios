import Testing
@testable import SharedModels

@Test func coordinateEqualityAndHashingMatchOnRowAndColumn() {
    #expect(Coordinate(row: 1, column: 2) == Coordinate(row: 1, column: 2))
    #expect(Coordinate(row: 1, column: 2) != Coordinate(row: 2, column: 1))

    let cells: Set<Coordinate> = [Coordinate(row: 0, column: 0), Coordinate(row: 0, column: 0)]
    #expect(cells.count == 1)
}
