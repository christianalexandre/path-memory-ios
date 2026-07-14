import Observation

enum LaunchPhase {
    case launching
    case ready
}

@MainActor
@Observable
final class LaunchViewModel {
    private(set) var phase: LaunchPhase = .launching
    private let bootstrap: @Sendable () async -> Void

    init(bootstrap: @escaping @Sendable () async -> Void = AppBootstrap.run) {
        self.bootstrap = bootstrap
    }

    func start() async {
        guard case .launching = phase else { return }
        await bootstrap()
        phase = .ready
    }
}
