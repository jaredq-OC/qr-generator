import Foundation

/// A single QR code history entry
struct QRHistoryEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let type: QRType
    let content: String
    let displayText: String
    let generatedAt: Date
    let thumbnailFileName: String?
    
    init(type: QRType, content: String, displayText: String, thumbnailFileName: String? = nil) {
        self.id = UUID()
        self.type = type
        self.content = content
        self.displayText = displayText
        self.generatedAt = Date()
        self.thumbnailFileName = thumbnailFileName
    }
    
    /// Truncated display text for history list
    var truncatedDisplay: String {
        if displayText.count > 30 {
            return String(displayText.prefix(27)) + "..."
        }
        return displayText
    }
    
    /// Formatted date for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: generatedAt)
    }
}
