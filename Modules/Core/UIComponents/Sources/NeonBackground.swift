import SwiftUI

@MainActor
public struct NeonBackground: View {
    private let showsDotGrid: Bool

    public init(showsDotGrid: Bool = false) {
        self.showsDotGrid = showsDotGrid
    }

    public var body: some View {
        ZStack {
            PMTheme.base
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: PMTheme.surfaceTop, location: 0),
                    .init(color: PMTheme.surfaceMid, location: 0.45),
                    .init(color: PMTheme.base, location: 1),
                ]),
                center: UnitPoint(x: 0.5, y: -0.1),
                startRadius: 0,
                endRadius: 900
            )
            if showsDotGrid {
                DotGridPattern()
            }
        }
        .ignoresSafeArea()
    }
}

private struct DotGridPattern: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 34
            let dotRadius: CGFloat = 1.4
            var yPos = spacing / 2
            while yPos < size.height {
                var xPos = spacing / 2
                while xPos < size.width {
                    let rect = CGRect(
                        x: xPos - dotRadius,
                        y: yPos - dotRadius,
                        width: dotRadius * 2,
                        height: dotRadius * 2
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(PMTheme.accent.opacity(0.08)))
                    xPos += spacing
                }
                yPos += spacing
            }
        }
        .opacity(0.55)
        .allowsHitTesting(false)
    }
}
