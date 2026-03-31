import SwiftUI

/// Displays the generated QR code with copy/share actions
struct QRCodeCard: View {
    let image: UIImage
    let showCopied: Bool
    let onCopy: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // QR Image
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Copied confirmation
            if showCopied {
                Label("Copied!", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Action buttons
            QRCodeActions(onCopy: onCopy, generatedImage: image)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
