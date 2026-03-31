import SwiftUI

/// Appearance mode settings sheet
struct AppearanceSettingsSheet: View {
    let selectedMode: AppearanceMode
    let onSelect: (AppearanceMode) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(AppearanceMode.allCases) { mode in
                    Button {
                        onSelect(mode)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: mode.icon)
                                .frame(width: 28)
                                .foregroundStyle(mode == selectedMode ? Color.accentColor : Color.secondary)
                            
                            Text(mode.displayName)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            if mode == selectedMode {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
