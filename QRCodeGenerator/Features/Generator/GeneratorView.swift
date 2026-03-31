import SwiftUI

/// Main single-screen QR code generator view
/// Designed for instant first paint: UI renders immediately, history loads in background
struct GeneratorView: View {
    @StateObject private var viewModel = GeneratorViewModel()
    
    var body: some View {
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
                
                // History — LazyHStack renders only visible items; thumbnails load async
                historySection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .ignoresSafeArea(.keyboard) // Prevent keyboard from compressing layout and causing overlap
        .safeAreaInset(edge: .top) { // Settings button properly in safe area — no overlap
            HStack {
                Spacer()
                Button {
                    viewModel.showSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .padding(8) // Adequate touch target
                }
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
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.generatedImage != nil)
        .task {
            // Wait 1 full second before loading history metadata
            // This ensures the first interactive frame renders with zero blocking
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            viewModel.loadHistory()
        }
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
                LazyHStack(spacing: 12) {
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
