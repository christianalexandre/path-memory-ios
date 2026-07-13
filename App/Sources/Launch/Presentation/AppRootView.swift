import SwiftUI

struct AppRootView: View {
    @State private var phase: AppPhase = .launching

    var body: some View {
        Group {
            switch phase {
            case .launching:
                SplashView()
            case .ready:
                AppRouter()
            }
        }
        .preferredColorScheme(.dark)
        .task {
            guard case .launching = phase else { return }
            await AppBootstrap.run()
            phase = .ready
        }
    }
}
