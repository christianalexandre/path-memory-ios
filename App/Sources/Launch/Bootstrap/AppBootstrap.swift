import Persistence

enum AppBootstrap {
    // TEMP: artificial hold so the splash is visible during development.
    private static let artificialDelay: Duration = .seconds(1.2)

    static func run() async {
        StorageBootstrap.install(StorageBootstrap.makeLive())
        try? await Task.sleep(for: artificialDelay)
    }
}
