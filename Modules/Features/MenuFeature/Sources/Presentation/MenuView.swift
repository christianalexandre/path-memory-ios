@_exported import SharedModels
import SwiftUI
import UIComponents

@MainActor
public struct MenuView: View {
    private let onPlay: (Difficulty) -> Void
    @State private var difficulty: Difficulty = .normal

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
            .padding(.horizontal, 26)
            .padding(.top, 10)
            .padding(.bottom, 24)
        }
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
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(PMTheme.accent)
                .frame(width: 46, height: 46)
                .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.09), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibility)
    }

    private var titleBlock: some View {
        VStack(spacing: 20) {
            bestScoreChip
            VStack(spacing: 0) {
                Text(verbatim: "Path")
                    .foregroundStyle(PMTheme.textPrimary)
                Text(verbatim: "Memory")
                    .foregroundStyle(PMTheme.accent)
                    .shadow(color: PMTheme.accent.opacity(0.6), radius: 20)
            }
            .font(.system(size: 52, weight: .bold, design: .rounded))
            Text("Trace the path from memory", bundle: .module)
                .font(.system(size: 13, design: .rounded))
                .foregroundStyle(PMTheme.textSecondary)
        }
    }

    private var bestScoreChip: some View {
        HStack(spacing: 8) {
            Text("Best", bundle: .module)
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .textCase(.uppercase)
                .kerning(1.8)
                .foregroundStyle(PMTheme.textSecondary)
            Text(verbatim: "1240")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(PMTheme.accent)
                .shadow(color: PMTheme.accent.opacity(0.5), radius: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.03), in: Capsule())
        .overlay(Capsule().strokeBorder(PMTheme.accent.opacity(0.22), lineWidth: 1))
    }

    private var controls: some View {
        VStack(spacing: 22) {
            VStack(spacing: 10) {
                Text("Difficulty", bundle: .module)
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .textCase(.uppercase)
                    .kerning(1.8)
                    .foregroundStyle(PMTheme.textFaint)
                DifficultyPills(options: Difficulty.allCases, selection: $difficulty, label: label(for:))
            }
            Button {
                onPlay(difficulty)
            } label: {
                HStack(spacing: 12) {
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
