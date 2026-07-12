import SwiftUI

@MainActor
public struct PathTrail: View {
    private let points: [GridPoint]
    private let color: Color
    private let metrics: GridMetrics
    private let isDashed: Bool

    public init(points: [GridPoint], color: Color, metrics: GridMetrics, isDashed: Bool = false) {
        self.points = points
        self.color = color
        self.metrics = metrics
        self.isDashed = isDashed
    }

    public var body: some View {
        Canvas { context, _ in
            guard points.count > 1 else { return }
            var path = Path()
            path.addLines(points.map { metrics.center(of: $0) })
            let width = isDashed ? metrics.ghostTrailWidth : metrics.trailWidth

            var glow = context
            glow.addFilter(.blur(radius: 4))
            glow.stroke(
                path,
                with: .color(color.opacity(0.22)),
                style: StrokeStyle(lineWidth: width * 2.4, lineCap: .round, lineJoin: .round)
            )

            var main = context
            main.addFilter(.shadow(color: color, radius: 4))
            main.stroke(
                path,
                with: .color(color.opacity(isDashed ? 0.7 : 1)),
                style: StrokeStyle(
                    lineWidth: width,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: isDashed ? [width * 1.6, width * 1.8] : []
                )
            )
        }
        .allowsHitTesting(false)
    }
}
