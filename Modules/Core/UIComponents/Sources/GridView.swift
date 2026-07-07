import SwiftUI

public struct GridConfiguration: Equatable, Sendable {
    public var dotsPerSide: Int
    public var litDots: Set<GridPoint> = []
    public var correctDots: Set<GridPoint> = []
    public var wrongDots: Set<GridPoint> = []
    public var ghostDots: Set<GridPoint> = []
    public var fingerDot: GridPoint?
    public var trail: [GridPoint] = []
    public var trailColor: Color = PMTheme.accent
    public var userTrail: [GridPoint] = []
    public var userTrailColor: Color = PMTheme.accent
    public var ghostTrail: [GridPoint] = []

    public init(dotsPerSide: Int) {
        self.dotsPerSide = dotsPerSide
    }

    func state(of point: GridPoint) -> DotState {
        if fingerDot == point {
            .finger
        } else if wrongDots.contains(point) {
            .wrong
        } else if correctDots.contains(point) {
            .correct
        } else if litDots.contains(point) {
            .lit
        } else if ghostDots.contains(point) {
            .ghost
        } else {
            .idle
        }
    }
}

@MainActor
public struct GridView: View {
    private let configuration: GridConfiguration

    public init(configuration: GridConfiguration) {
        self.configuration = configuration
    }

    public var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let metrics = GridMetrics(dotsPerSide: configuration.dotsPerSide, sideLength: side)
            ZStack(alignment: .topLeading) {
                if !configuration.ghostTrail.isEmpty {
                    PathTrail(
                        points: configuration.ghostTrail,
                        color: PMTheme.accent.opacity(0.4),
                        metrics: metrics,
                        isDashed: true
                    )
                }
                if !configuration.trail.isEmpty {
                    PathTrail(points: configuration.trail, color: configuration.trailColor, metrics: metrics)
                }
                if !configuration.userTrail.isEmpty {
                    PathTrail(points: configuration.userTrail, color: configuration.userTrailColor, metrics: metrics)
                }
                ForEach(0 ..< configuration.dotsPerSide * configuration.dotsPerSide, id: \.self) { index in
                    let point = GridPoint(index / configuration.dotsPerSide, index % configuration.dotsPerSide)
                    DotView(state: configuration.state(of: point), diameter: metrics.dotDiameter)
                        .position(metrics.center(of: point))
                }
                if let finger = configuration.fingerDot {
                    TouchDisc(radius: max(metrics.dotDiameter * 1.6, 24))
                        .position(metrics.center(of: finger))
                }
            }
            .frame(width: side, height: side)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

private struct TouchDisc: View {
    let radius: CGFloat
    @State private var pulsing = false

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [PMTheme.accent.opacity(0.22), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: radius
                )
            )
            .overlay(Circle().strokeBorder(PMTheme.accentBright.opacity(0.45), lineWidth: 1.5))
            .frame(width: radius * 2, height: radius * 2)
            .shadow(color: PMTheme.accent.opacity(0.35), radius: 11)
            .scaleEffect(pulsing ? 1.18 : 1)
            .opacity(pulsing ? 0.5 : 0.85)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    pulsing = true
                }
            }
    }
}
