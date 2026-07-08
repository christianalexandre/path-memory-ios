import Dependencies

/// Feature-local: only Game uses haptics.
public protocol HapticsService: Sendable {
    func success()
    func failure()
}

public struct NoopHapticsService: HapticsService {
    public init() {}
    public func success() {}
    public func failure() {}
}

private enum HapticsServiceKey: DependencyKey {
    static let liveValue: any HapticsService = NoopHapticsService()
}

public extension DependencyValues {
    var hapticsService: any HapticsService {
        get { self[HapticsServiceKey.self] }
        set { self[HapticsServiceKey.self] = newValue }
    }
}
