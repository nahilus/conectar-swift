import SwiftUI

struct SkillChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body:
    some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background( Capsule(style: .continuous)
                .fill(isSelected ? Color(.label) : Color.white) )
            .foregroundStyle(isSelected ? .white : Color.primary)
            .overlay( Capsule(style: .continuous) .stroke(isSelected ? Color.clear : Color.black.opacity(0.12)) ) .shadow(color: isSelected ? Color.black.opacity(0.15) : Color.clear, radius: 6, x: 0, y: 3) } .buttonStyle(.plain) } }
