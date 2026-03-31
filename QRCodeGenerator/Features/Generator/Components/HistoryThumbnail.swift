import SwiftUI

/// History entry thumbnail with per-item staggered async loading
/// Each thumbnail waits a unique delay (derived from its UUID hash) before loading
/// This prevents 10 concurrent loads from all starting simultaneously
struct HistoryThumbnail: View {
    let entry: QRHistoryEntry
    let onTap: () -> Void
    
    @State private var thumbnailImage: UIImage?
    
    /// Computed unique stagger delay from UUID hash (50-500ms range)
    private var staggerDelay: UInt64 {
        let hash = abs(entry.id.uuidString.hashValue)
        let delayMs = 50 + (hash % 450) // 50-500ms unique delay
        return UInt64(delayMs) * 1_000_000 // to nanoseconds
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Thumbnail
                Group {
                    if let image = thumbnailImage {
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
                }
                
                // Label
                Text(entry.type.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .task(id: entry.id) {
            // Wait for unique stagger delay — prevents concurrent load burst
            try? await Task.sleep(nanoseconds: staggerDelay)
            guard !Task.isCancelled else { return }
            
            // Load on background thread — thumbnail I/O is off main thread
            let image = await Task.detached(priority: .utility) {
                guard let filename = entry.thumbnailFileName else { return nil as UIImage? }
                return HistoryService.loadThumbnail(filename: filename)
            }.value
            
            guard !Task.isCancelled else { return }
            thumbnailImage = image
        }
    }
}
