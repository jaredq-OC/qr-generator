import SwiftUI

/// Copy and Share action buttons for QR code
struct QRCodeActions: View {
    let onCopy: () -> Void
    let generatedImage: UIImage
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                onCopy()
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(.tertiarySystemBackground))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            ShareLink(item: Image(uiImage: generatedImage), preview: SharePreview("QR Code", image: Image(uiImage: generatedImage))) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
