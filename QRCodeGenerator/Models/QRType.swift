import Foundation

/// Types of QR codes supported
enum QRType: String, CaseIterable, Identifiable, Codable {
    case url = "URL"
    case text = "Text"
    case wifi = "WiFi"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .url: return "link"
        case .text: return "textformat"
        case .wifi: return "wifi"
        }
    }
}
