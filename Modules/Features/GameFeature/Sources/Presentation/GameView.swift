@_exported import SharedModels
import SwiftUI
import UIComponents

@MainActor
public struct GameView: View {
    @State private var viewModel: GameViewModel
    private let onExit: () -> Void
    private let drivesPhases: Bool

    public init(difficulty: Difficulty, onExit: @escaping () -> Void) {
        _viewModel = State(initialValue: GameViewModel(difficulty: difficulty))
        self.onExit = onExit
        drivesPhases = true
    }

    /// Test seam: inject a pre-driven view model and freeze the phase driver.
    init(viewModel: GameViewModel, onExit: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onExit = onExit
        drivesPhases = false
    }

    public var body: some View {
        ZStack {
            NeonBackground()
            VStack(spacing: 0) {
                closeRow
                HUDView(score: viewModel.score, level: viewModel.level, lives: viewModel.lives)
                    .padding(.top, PMSpace.lg)
                bannerView
                    .padding(.top, PMSpace.xxl)
                Spacer()
                GridView(
                    configuration: gridConfiguration,
                    onTouch: { viewModel.handleTouch(Coordinate(row: $0.row, column: $0.column)) },
                    onTouchEnded: { viewModel.endTouch() }
                )
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, PMSpace.sm)
                Spacer()
            }
            .padding(.horizontal, PMSpace.xxl)
            .padding(.top, PMSpace.md)
            .padding(.bottom, PMSpace.xxl)

            if viewModel.phase == .gameOver {
                ResultView(
                    score: viewModel.finalScore,
                    best: viewModel.bestScore,
                    review: reviewConfiguration,
                    onRetry: { viewModel.retry() },
                    onMenu: onExit
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.phase)
        .task(id: viewModel.phase) {
            guard drivesPhases else { return }
            switch viewModel.phase {
            case .idle: viewModel.begin()
            case .revealing: await viewModel.reveal()
            case .phaseCleared: await viewModel.advance()
            default: break
            }
        }
    }

    private var gridConfiguration: GridConfiguration {
        var config = GridConfiguration(dotsPerSide: viewModel.gridSize)
        let pathPoints = viewModel.path.coordinates.map(gridPoint)
        switch viewModel.phase {
        case .idle, .revealing:
            config.litDots = Set(pathPoints)
            config.trail = pathPoints
        case .recalling:
            let traced = viewModel.activated.map(gridPoint)
            config.correctDots = Set(traced)
            config.userTrail = traced
            config.userTrailColor = PMTheme.success
            if let finger = viewModel.fingerCell {
                config.fingerDot = gridPoint(finger)
            }
            if let wrong = viewModel.wrongCell {
                config.wrongDots = [gridPoint(wrong)]
            }
        case .phaseCleared:
            config.correctDots = Set(pathPoints)
            config.trail = pathPoints
            config.trailColor = PMTheme.success
        case .gameOver:
            break
        }
        return config
    }

    private var reviewConfiguration: GridConfiguration? {
        guard let review = viewModel.review else { return nil }
        var config = GridConfiguration(dotsPerSide: viewModel.gridSize)
        let path = review.path.map(gridPoint)
        config.ghostDots = Set(path)
        config.ghostTrail = path
        let trace = review.trace.map(gridPoint)
        config.correctDots = Set(trace)
        config.userTrail = trace
        config.userTrailColor = PMTheme.success
        config.wrongDots = [gridPoint(review.wrong)]
        return config
    }

    private func gridPoint(_ coordinate: Coordinate) -> GridPoint {
        GridPoint(coordinate.row, coordinate.column)
    }

    @ViewBuilder
    private var bannerView: some View {
        switch viewModel.phase {
        case .recalling where viewModel.wrongCell != nil:
            PhaseBanner(Text("Missed", bundle: .module), tone: .danger)
        case .recalling:
            PhaseBanner(Text("Recall!", bundle: .module))
        case .phaseCleared:
            PhaseBanner(Text("Perfect!", bundle: .module), tone: .success)
        default:
            PhaseBanner(Text("Memorize!", bundle: .module))
        }
    }

    private var closeRow: some View {
        HStack {
            Button(action: onExit) {
                Image(systemName: "xmark")
                    .font(PMFont.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(PMTheme.textSecondary)
                    .frame(width: 32, height: 32)
                    .background(PMTheme.fillSubtle, in: Circle())
                    .overlay(Circle().strokeBorder(PMTheme.strokeSubtle, lineWidth: PMStroke.hairline))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Close", bundle: .module))
            Spacer()
        }
    }
}

#Preview {
    GameView(difficulty: .normal, onExit: {})
}
