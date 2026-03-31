import Foundation
import UIKit

/// Manages QR history persistence: UserDefaults for metadata + Documents/Thumbnails/ for images
enum HistoryService {
    private static let userDefaultsKey = "qr_history_entries"
    private static let maxEntries = 10
    private static let thumbnailsDir = "Thumbnails"
    
    /// Loads all history entries from UserDefaults
    static func loadEntries() -> [QRHistoryEntry] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([QRHistoryEntry].self, from: data)
        } catch {
            print("HistoryService: Failed to decode entries: \(error)")
            return []
        }
    }
    
    /// Saves an entry to history, enforcing FIFO limit of 10
    static func save(entry: QRHistoryEntry) {
        var entries = loadEntries()
        
        // Remove oldest if at capacity
        while entries.count >= maxEntries {
            if let oldest = entries.first,
               let thumbnailName = oldest.thumbnailFileName {
                deleteThumbnail(filename: thumbnailName)
            }
            entries.removeFirst()
        }
        
        entries.append(entry)
        persist(entries: entries)
    }
    
    /// Regenerates a QR from a history entry
    static func regenerate(from entry: QRHistoryEntry) -> UIImage? {
        return QRCodeService.generateQRImage(from: entry.content, size: 300)
    }
    
    /// Loads a thumbnail image for a history entry
    static func loadThumbnail(filename: String) -> UIImage? {
        guard let url = thumbnailURL(filename: filename) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Private
    
    private static func persist(entries: [QRHistoryEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("HistoryService: Failed to encode entries: \(error)")
        }
    }
    
    private static func thumbnailURL(filename: String) -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent(thumbnailsDir).appendingPathComponent(filename)
    }
    
    private static func ensureThumbnailsDirectory() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let dirURL = documentsURL.appendingPathComponent(thumbnailsDir)
        try? FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
    }
    
    /// Saves a thumbnail image and returns the filename
    @discardableResult
    static func saveThumbnail(image: UIImage, id: UUID) -> String? {
        ensureThumbnailsDirectory()
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let filename = "\(id.uuidString).png"
        let fileURL = documentsURL.appendingPathComponent(thumbnailsDir).appendingPathComponent(filename)
        
        guard let data = image.pngData() else { return nil }
        do {
            try data.write(to: fileURL)
            return filename
        } catch {
            print("HistoryService: Failed to save thumbnail: \(error)")
            return nil
        }
    }
    
    private static func deleteThumbnail(filename: String) {
        guard let url = thumbnailURL(filename: filename) else { return }
        try? FileManager.default.removeItem(at: url)
    }
}
