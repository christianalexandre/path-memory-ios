/// Raw value is persisted, so keep it stable.
public enum Difficulty: String, CaseIterable, Hashable, Sendable {
    case easy
    case normal
    case hard
}
