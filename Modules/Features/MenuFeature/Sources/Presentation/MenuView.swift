import Dependencies
import Persistence
@_exported import SharedModels
import SwiftUI
import UIComponents

@MainActor
public struct MenuView: View {
    private let onPlay: (Difficulty) -> Void
    @State private var difficulty: Difficulty = .normal
    @State private var bestScore = 0
    @Dependency(\.storageRepository) private var storage

    public init(onPlay: @escaping (Difficulty) -> Void) {
        self.onPlay = onPlay
    }

    public var body: some View {
        ZStack {
            NeonBackground(showsDotGrid: true)
            VStack(spacing: 0) {
                topBar
                Spacer()
                titleBlock
                Spacer()
                controls
            }
            .padding(.horizontal, PMSpace.xxl)
            .padding(.top, PMSpace.md)
            .padding(.bottom, PMSpace.xxl)
        }
        .task(id: difficulty) {
            await refreshBestScore()
        }
    }

    /// Off the main actor: the first storage access opens the database and runs
    /// migrations, which must not block a body evaluation.
    private func refreshBestScore() async {
        let storage = storage
        let difficulty = difficulty
        bestScore = await Task.detached {
            storage.bestScore(for: difficulty)
        }.value
    }

    private var topBar: some View {
        HStack {
            iconButton(systemName: "chart.bar.fill", accessibility: Text("Statistics", bundle: .module))
            Spacer()
            iconButton(systemName: "slider.horizontal.3", accessibility: Text("Settings", bundle: .module))
        }
    }

    private func iconButton(systemName: String, accessibility: Text) -> some View {
        Button {
            // No-op until stats/settings exist.
        } label: {
            Image(systemName: systemName)
                .font(PMFont.callout)
                .foregroundStyle(PMTheme.accent)
                .frame(width: 48, height: 48)
                .background(PMTheme.fillSubtle, in: RoundedRectangle(cornerRadius: PMRadius.lg))
                .overlay(RoundedRectangle(cornerRadius: PMRadius.lg).strokeBorder(
                    PMTheme.strokeSubtle,
                    lineWidth: PMStroke.hairline
                ))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibility)
    }

    private var titleBlock: some View {
        VStack(spacing: PMSpace.xl) {
            bestScoreChip
            VStack(spacing: 0) {
                Text(verbatim: "Path")
                    .foregroundStyle(PMTheme.textPrimary)
                Text(verbatim: "Memory")
                    .foregroundStyle(PMTheme.accent)
                    .shadow(color: PMTheme.accent.opacity(0.6), radius: 20)
            }
            .font(PMFont.display)
            Text("Trace the path from memory", bundle: .module)
                .font(PMFont.caption)
                .fontWeight(.regular)
                .foregroundStyle(PMTheme.textSecondary)
        }
    }

    private var bestScoreChip: some View {
        HStack(spacing: PMSpace.sm) {
            Text("Best", bundle: .module)
                .font(PMFont.overline)
                .textCase(.uppercase)
                .kerning(1.8)
                .foregroundStyle(PMTheme.textSecondary)
            Text(verbatim: "\(bestScore)")
                .font(PMFont.callout)
                .fontWeight(.bold)
                .foregroundStyle(PMTheme.accent)
                .shadow(color: PMTheme.accent.opacity(0.5), radius: 6)
        }
        .padding(.horizontal, PMSpace.lg)
        .padding(.vertical, PMSpace.sm)
        .background(PMTheme.fillSubtle, in: Capsule())
        .overlay(Capsule().strokeBorder(PMTheme.accent.opacity(0.22), lineWidth: PMStroke.hairline))
    }

    private var controls: some View {
        VStack(spacing: PMSpace.xxl) {
            VStack(spacing: PMSpace.md) {
                Text("Difficulty", bundle: .module)
                    .font(PMFont.overline)
                    .textCase(.uppercase)
                    .kerning(1.8)
                    .foregroundStyle(PMTheme.textFaint)
                DifficultyPills(options: Difficulty.allCases, selection: $difficulty, label: label(for:))
            }
            Button {
                onPlay(difficulty)
            } label: {
                HStack(spacing: PMSpace.md) {
                    Image(systemName: "play.fill")
                    Text("Play", bundle: .module)
                }
            }
            .buttonStyle(.neonPrimary)
        }
    }

    private func label(for difficulty: Difficulty) -> Text {
        switch difficulty {
        case .easy: Text("Easy", bundle: .module)
        case .normal: Text("Normal", bundle: .module)
        case .hard: Text("Hard", bundle: .module)
        }
    }
}

#Preview {
    MenuView(onPlay: { _ in })
}
