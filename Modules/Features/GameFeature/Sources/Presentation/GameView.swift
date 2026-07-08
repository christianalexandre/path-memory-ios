@_exported import SharedModels
import SwiftUI
import UIComponents

@MainActor
public struct GameView: View {
    @State private var viewModel: GameViewModel
    private let onExit: () -> Void

    public init(difficulty: Difficulty, onExit: @escaping () -> Void) {
        _viewModel = State(initialValue: GameViewModel(difficulty: difficulty))
        self.onExit = onExit
    }

    public var body: some View {
        ZStack {
            NeonBackground()
            VStack(spacing: 0) {
                closeRow
                HUDView(score: viewModel.score, level: viewModel.level, lives: viewModel.lives)
                    .padding(.top, 14)
                bannerView
                    .padding(.top, 24)
                Spacer()
                GridView(
                    configuration: gridConfiguration,
                    onTouch: { viewModel.handleTouch(Coordinate(row: $0.row, column: $0.column)) },
                    onTouchEnded: { viewModel.endTouch() }
                )
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 6)
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.top, 10)
            .padding(.bottom, 22)

            if viewModel.phase == .gameOver {
                ResultView(
                    score: viewModel.finalScore,
                    best: viewModel.bestScore,
                    onRetry: { viewModel.retry() },
                    onMenu: onExit
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.phase)
        .onAppear { viewModel.begin() }
        .task(id: viewModel.phase) {
            switch viewModel.phase {
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
            config.litDots = Set(pathPoints)
            config.trail = pathPoints
        }
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
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PMTheme.textSecondary)
                    .frame(width: 34, height: 34)
                    .background(Color.white.opacity(0.04), in: Circle())
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.09), lineWidth: 1))
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
