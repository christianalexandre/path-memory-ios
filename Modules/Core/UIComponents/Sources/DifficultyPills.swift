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
        HStack(spacing: 6) {
            ForEach(options, id: \.self) { option in
                pill(for: option)
            }
        }
        .padding(5)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Color.white.opacity(0.07), lineWidth: 1))
    }

    private func pill(for option: Option) -> some View {
        let isSelected = option == selection
        return Button {
            withAnimation(.easeOut(duration: 0.18)) {
                selection = option
            }
        } label: {
            label(option)
                .font(.system(size: 14, weight: isSelected ? .bold : .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? PMTheme.onAccent : PMTheme.textPrimary.opacity(0.45))
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 14)
                    .fill(PMTheme.pillGradient)
                    .shadow(color: PMTheme.accent.opacity(0.45), radius: 11)
            }
        }
    }
}
