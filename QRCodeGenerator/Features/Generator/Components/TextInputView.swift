import SwiftUI

/// Plain text input field
struct TextInputView: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image(systemName: "textformat")
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                TextField("Enter text or message...", text: $text, axis: .vertical)
                    .lineLimit(3...6)
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
