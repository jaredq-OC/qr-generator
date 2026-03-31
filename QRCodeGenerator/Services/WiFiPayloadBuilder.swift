import Foundation

/// WiFi QR payload builder per ISO/IEC 18004:2006
/// Formats: WIFI:T:<enc>;S:<ssid>;P:<password>;;
enum WiFiPayloadBuilder {
    enum Encryption: String, CaseIterable {
        case wpa = "WPA"
        case wep = "WEP"
        case none = "nopass"
        
        var displayName: String {
            switch self {
            case .wpa: return "WPA/WPA2"
            case .wep: return "WEP"
            case .none: return "None"
            }
        }
    }
    
    /// Escapes special characters in WiFi payload strings per ISO/IEC 18004:2006
    /// Characters that need escaping: \ ; :
    private static func escape(_ s: String) -> String {
        s
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: ";", with: "\\;")
            .replacingOccurrences(of: ":", with: "\\:")
    }
    
    /// Builds a WiFi QR payload string
    /// - Parameters:
    ///   - ssid: Network SSID (required)
    ///   - password: Network password (ignored if encryption is .none)
    ///   - encryption: Encryption type
    ///   - isHidden: Whether the network is hidden
    /// - Returns: Properly formatted WiFi payload string
    static func build(ssid: String, password: String, encryption: Encryption, isHidden: Bool = false) -> String {
        let escapedSSID = escape(ssid)
        let escapedPassword = escape(password)
        
        var payload = "WIFI:T:\(encryption.rawValue);S:\(escapedSSID);"
        
        if encryption != .none {
            payload += "P:\(escapedPassword);"
        }
        
        if isHidden {
            payload += "H:true;"
        }
        
        payload += ";"
        return payload
    }
}
