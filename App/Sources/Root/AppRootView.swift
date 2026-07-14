import SwiftUI

struct AppRootView: View {
    @State private var model = LaunchViewModel()

    var body: some View {
        Group {
            switch model.phase {
            case .launching:
                SplashView()
            case .ready:
                AppRouter()
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await model.start()
        }
    }
}
