import Dependencies

#if canImport(UIKit)
    import UIKit
#endif

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

public struct SystemHapticsService: HapticsService {
    public init() {}

    public func success() {
        #if canImport(UIKit)
            fire(.success)
        #endif
    }

    public func failure() {
        #if canImport(UIKit)
            fire(.error)
        #endif
    }

    #if canImport(UIKit)
        private func fire(_ type: UINotificationFeedbackGenerator.FeedbackType) {
            MainActor.assumeIsolated {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(type)
            }
        }
    #endif
}

private enum HapticsServiceKey: DependencyKey {
    static let liveValue: any HapticsService = SystemHapticsService()
    static let testValue: any HapticsService = NoopHapticsService()
}

public extension DependencyValues {
    var hapticsService: any HapticsService {
        get { self[HapticsServiceKey.self] }
        set { self[HapticsServiceKey.self] = newValue }
    }
}
