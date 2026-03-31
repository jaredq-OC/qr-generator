import SwiftUI

/// History entry thumbnail button
struct HistoryThumbnail: View {
    let entry: QRHistoryEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Thumbnail
                if let filename = entry.thumbnailFileName,
                   let image = HistoryService.loadThumbnail(filename: filename) {
                    Image(uiImage: image)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(4)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemBackground))
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: entry.type.icon)
                                .foregroundStyle(.secondary)
                        }
                }
                
                // Label
                Text(entry.type.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}
