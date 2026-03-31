import SwiftUI

/// WiFi credentials input form
struct WiFiInputView: View {
    @Binding var credentials: WiFiCredentials
    
    var body: some View {
        VStack(spacing: 16) {
            // SSID
            VStack(alignment: .leading, spacing: 8) {
                Text("Network Name (SSID)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack {
                    Image(systemName: "wifi")
                        .foregroundStyle(.secondary)
                    TextField("SSID", text: $credentials.ssid)
                        .autocorrectionDisabled()
                }
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Encryption type
            VStack(alignment: .leading, spacing: 8) {
                Text("Security")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Encryption", selection: $credentials.encryption) {
                    ForEach(WiFiPayloadBuilder.Encryption.allCases, id: \.self) { enc in
                        Text(enc.displayName).tag(enc)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Password (if not open network)
            if credentials.encryption != .none {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    SecureField("Password", text: $credentials.password)
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // Hidden network toggle
            Toggle(isOn: $credentials.isHidden) {
                HStack {
                    Image(systemName: "eye.slash")
                        .foregroundStyle(.secondary)
                    Text("Hidden Network")
                }
            }
            .padding(.horizontal, 4)
        }
    }
}
