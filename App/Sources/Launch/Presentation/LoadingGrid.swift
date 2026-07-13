import SwiftUI
import UIComponents

struct LoadingGrid: View {
    private static let path = [GridPoint(0, 0), GridPoint(0, 1), GridPoint(1, 1), GridPoint(1, 0)]
    private static let frames = makeFrames(path)

    @State private var frame = 0

    var body: some View {
        var configuration = GridConfiguration(dotsPerSide: 2)
        configuration.litDots = Self.frames[frame]
        return GridView(configuration: configuration)
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(PMDuration.medium))
                    withAnimation(.easeInOut(duration: PMDuration.medium)) {
                        frame = (frame + 1) % Self.frames.count
                    }
                }
            }
    }

    private static func makeFrames(_ path: [GridPoint]) -> [Set<GridPoint>] {
        let fill = (0 ... path.count).map { Set(path.prefix($0)) }
        let drain = (1 ..< path.count).map { Set(path.suffix(path.count - $0)) }
        return fill + drain
    }
}

#Preview {
    ZStack {
        NeonBackground()
        LoadingGrid().frame(width: 96, height: 96)
    }
}
