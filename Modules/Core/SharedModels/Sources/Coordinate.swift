/// Shared by Domain and Persistence; the UI's `GridPoint` is mapped from it so
/// this type carries no UI dependency.
public struct Coordinate: Hashable, Sendable {
    public let row: Int
    public let column: Int

    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
