import Foundation

/// WiFi network credentials
struct WiFiCredentials: Equatable {
    var ssid: String = ""
    var password: String = ""
    var encryption: WiFiPayloadBuilder.Encryption = .wpa
    var isHidden: Bool = false
    
    var isValid: Bool {
        !ssid.isEmpty
    }
    
    /// Builds the QR payload string
    var payload: String {
        WiFiPayloadBuilder.build(
            ssid: ssid,
            password: password,
            encryption: encryption,
            isHidden: isHidden
        )
    }
}
