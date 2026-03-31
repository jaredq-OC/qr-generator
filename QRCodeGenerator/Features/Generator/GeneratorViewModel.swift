import SwiftUI
import UIKit
import Combine

/// Main view model for the QR code generator
@MainActor
final class GeneratorViewModel: ObservableObject {
    // MARK: - Input State
    @Published var selectedType: QRType = .url
    @Published var urlInput: String = ""
    @Published var textInput: String = ""
    @Published var wifiCredentials: WiFiCredentials = WiFiCredentials()
    
    // MARK: - Output State
    @Published var generatedImage: UIImage?
    @Published var historyEntries: [QRHistoryEntry] = []
    @Published var appearanceMode: AppearanceMode = .system
    @Published var showSettings: Bool = false
    @Published var showCopiedConfirmation: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Computed
    
    /// The current input string based on selected type
    var currentInput: String {
        switch selectedType {
        case .url:
            var url = urlInput.trimmingCharacters(in: .whitespacesAndNewlines)
            if !url.isEmpty && !url.contains("://") {
                url = "https://" + url
            }
            return url
        case .text:
            return textInput
        case .wifi:
            return wifiCredentials.payload
        }
    }
    
    /// Whether generate button should be enabled
    var canGenerate: Bool {
        switch selectedType {
        case .url: return !urlInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .text: return !textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .wifi: return wifiCredentials.isValid
        }
    }
    
    /// Display text for the current input
    var displayText: String {
        switch selectedType {
        case .url: return urlInput.isEmpty ? "" : urlInput
        case .text: return textInput.isEmpty ? "" : textInput
        case .wifi: return wifiCredentials.ssid
        }
    }
    
    // MARK: - Actions
    
    func generateQR() {
        errorMessage = nil
        let input = currentInput
        
        guard !input.isEmpty else {
            errorMessage = "Please enter something to encode"
            return
        }
        
        guard let image = QRCodeService.generateQRImage(from: input, size: 300) else {
            errorMessage = "Failed to generate QR code"
            return
        }
        
        generatedImage = image
        
        // Save to history with thumbnail
        let thumbnailFilename: String?
        if let thumbnail = QRCodeService.generateThumbnail(from: input) {
            thumbnailFilename = HistoryService.saveThumbnail(image: thumbnail, id: UUID())
        } else {
            thumbnailFilename = nil
        }
        
        let entry = QRHistoryEntry(
            type: selectedType,
            content: input,
            displayText: displayText,
            thumbnailFileName: thumbnailFilename
        )
        
        HistoryService.save(entry: entry)
        historyEntries = HistoryService.loadEntries()
    }
    
    func copyToClipboard() {
        guard let image = generatedImage else { return }
        UIPasteboard.general.image = image
        showCopied()
    }
    
    func loadHistory() {
        historyEntries = HistoryService.loadEntries()
    }
    
    func regenerateFromHistory(_ entry: QRHistoryEntry) {
        selectedType = entry.type
        switch entry.type {
        case .url:
            urlInput = entry.content
            textInput = ""
            wifiCredentials = WiFiCredentials()
        case .text:
            textInput = entry.content
            urlInput = ""
            wifiCredentials = WiFiCredentials()
        case .wifi:
            wifiCredentials = WiFiCredentials()
            urlInput = ""
            textInput = ""
        }
        generatedImage = HistoryService.regenerate(from: entry)
    }
    
    func setAppearanceMode(_ mode: AppearanceMode) {
        appearanceMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: "appearanceMode")
    }
    
    // MARK: - Private
    
    private func showCopied() {
        showCopiedConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            self?.showCopiedConfirmation = false
        }
    }
}
