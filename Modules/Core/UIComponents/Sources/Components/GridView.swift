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
    private let onTouch: ((GridPoint) -> Void)?
    private let onTouchEnded: (() -> Void)?
    @State private var lastTouched: GridPoint?

    public init(
        configuration: GridConfiguration,
        onTouch: ((GridPoint) -> Void)? = nil,
        onTouchEnded: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onTouch = onTouch
        self.onTouchEnded = onTouchEnded
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
            .contentShape(Rectangle())
            .gesture(dragGesture(metrics: metrics))
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }

    private func dragGesture(metrics: GridMetrics) -> some Gesture {
        // minimumDistance 0 so a tap registers the same as a drag.
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard let point = metrics.dot(near: value.location), point != lastTouched else { return }
                if let previous = lastTouched {
                    for skipped in GridMetrics.straightLine(from: previous, to: point) {
                        onTouch?(skipped)
                    }
                }
                onTouch?(point)
                lastTouched = point
            }
            .onEnded { _ in
                lastTouched = nil
                onTouchEnded?()
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
            .overlay(Circle().strokeBorder(PMTheme.accentBright.opacity(0.45), lineWidth: PMStroke.thin))
            .frame(width: radius * 2, height: radius * 2)
            .shadow(color: PMTheme.accent.opacity(0.35), radius: 11)
            .scaleEffect(pulsing ? 1.18 : 1)
            .opacity(pulsing ? 0.5 : 0.85)
            .onAppear {
                withAnimation(.easeInOut(duration: PMDuration.slow).repeatForever(autoreverses: true)) {
                    pulsing = true
                }
            }
    }
}
