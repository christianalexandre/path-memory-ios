import SwiftUI
import UIComponents

struct SplashView: View {
    var body: some View {
        ZStack {
            NeonBackground()
            LoadingGrid()
                .frame(width: 96, height: 96)
        }
    }
}

#Preview {
    SplashView()
}
