import SwiftUI

@MainActor
public struct DifficultyPills<Option: Hashable>: View {
    private let options: [Option]
    @Binding private var selection: Option
    private let label: (Option) -> Text

    public init(options: [Option], selection: Binding<Option>, label: @escaping (Option) -> Text) {
        self.options = options
        _selection = selection
        self.label = label
    }

    public var body: some View {
        HStack(spacing: PMSpace.sm) {
            ForEach(options, id: \.self) { option in
                pill(for: option)
            }
        }
        .padding(PMSpace.xs)
        .background(PMTheme.fillSubtle, in: RoundedRectangle(cornerRadius: PMRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: PMRadius.xl).strokeBorder(
            PMTheme.strokeFaint,
            lineWidth: PMStroke.hairline
        ))
    }

    private func pill(for option: Option) -> some View {
        let isSelected = option == selection
        return Button {
            withAnimation(.easeOut(duration: 0.18)) {
                selection = option
            }
        } label: {
            label(option)
                .font(PMFont.body)
                .fontWeight(isSelected ? .bold : .semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, PMSpace.md)
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? PMTheme.onAccent : PMTheme.textPrimary.opacity(0.45))
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: PMRadius.lg)
                    .fill(PMTheme.pillGradient)
                    .shadow(color: PMTheme.accent.opacity(0.45), radius: 11)
            }
        }
    }
}
