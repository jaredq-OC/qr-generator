import SwiftUI

/// History entry thumbnail with async image loading for fast launch
struct HistoryThumbnail: View {
    let entry: QRHistoryEntry
    let onTap: () -> Void
    
    @State private var thumbnailImage: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Thumbnail — shows placeholder while loading
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
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                } else {
                                    Image(systemName: entry.type.icon)
                                        .foregroundStyle(.secondary)
                                }
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
            await loadThumbnail()
        }
    }
    
    private func loadThumbnail() async {
        guard let filename = entry.thumbnailFileName else {
            isLoading = false
            return
        }
        
        // Load on background thread to avoid blocking UI
        let image = await Task.detached(priority: .userInitiated) {
            HistoryService.loadThumbnail(filename: filename)
        }.value
        
        // Only update if still showing the same entry
        if !Task.isCancelled {
            thumbnailImage = image
            isLoading = false
        }
    }
}
