import SwiftUI

@MainActor
public struct PMWordmark: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            Text(verbatim: "Path")
                .foregroundStyle(PMTheme.textPrimary)
            Text(verbatim: "Memory")
                .foregroundStyle(PMTheme.accent)
                .shadow(color: PMTheme.accent.opacity(0.6), radius: 20)
        }
        .font(PMFont.display)
    }
}

#Preview {
    PMWordmark()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PMTheme.base)
}
