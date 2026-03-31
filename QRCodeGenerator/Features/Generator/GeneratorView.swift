import SwiftUI

/// Main single-screen QR code generator view
struct GeneratorView: View {
    @StateObject private var viewModel = GeneratorViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Segmented type picker
                    typePicker
                    
                    // Conditional input
                    inputSection
                    
                    // Generate button
                    generateButton
                    
                    // QR Code card
                    if let image = viewModel.generatedImage {
                        QRCodeCard(image: image, showCopied: viewModel.showCopiedConfirmation, onCopy: {
                            viewModel.copyToClipboard()
                        })
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                    
                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    // History
                    if !viewModel.historyEntries.isEmpty {
                        historySection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            
            // Settings button overlay
            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .sheet(isPresented: $viewModel.showSettings) {
            AppearanceSettingsSheet(
                selectedMode: viewModel.appearanceMode,
                onSelect: { mode in
                    viewModel.setAppearanceMode(mode)
                }
            )
            .presentationDetents([.medium])
        }
        .onAppear {
            viewModel.loadHistory()
            if let stored = UserDefaults.standard.string(forKey: "appearanceMode"),
               let mode = AppearanceMode(rawValue: stored) {
                viewModel.appearanceMode = mode
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.generatedImage != nil)
    }
    
    // MARK: - Subviews
    
    private var typePicker: some View {
        Picker("Type", selection: $viewModel.selectedType) {
            ForEach(QRType.allCases) { type in
                Label(type.rawValue, systemImage: type.icon)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private var inputSection: some View {
        switch viewModel.selectedType {
        case .url:
            URLInputView(text: $viewModel.urlInput)
        case .text:
            TextInputView(text: $viewModel.textInput)
        case .wifi:
            WiFiInputView(credentials: $viewModel.wifiCredentials)
        }
    }
    
    private var generateButton: some View {
        Button {
            viewModel.generateQR()
        } label: {
            Text("Generate QR Code")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(viewModel.canGenerate ? Color.accentColor : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!viewModel.canGenerate)
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.historyEntries.reversed()) { entry in
                        HistoryThumbnail(entry: entry) {
                            viewModel.regenerateFromHistory(entry)
                        }
                    }
                }
            }
        }
    }
}
