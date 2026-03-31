import Foundation
import UIKit

/// Manages QR history persistence: UserDefaults for metadata + Documents/Thumbnails/ for images
enum HistoryService {
    private static let userDefaultsKey = "qr_history_entries"
    private static let maxEntries = 10
    private static let thumbnailsDir = "Thumbnails"
    
    /// Loads all history entries from UserDefaults
    static func loadEntries() -> [QRHistoryEntry] {
        // Ensure thumbnails directory exists before any thumbnail access
        ensureThumbnailsDirectory()
        
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
    /// Returns nil gracefully if file doesn't exist (handles deleted/orphaned thumbnails)
    static func loadThumbnail(filename: String) -> UIImage? {
        guard !filename.isEmpty else { return nil }
        guard let url = thumbnailURL(filename: filename) else { return nil }
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("HistoryService: Thumbnail file not found: \(url.path)")
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            print("HistoryService: Failed to read thumbnail data: \(url.path)")
            return nil
        }
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
            print("HistoryService: Could not locate Documents directory")
            return nil
        }
        return documentsURL.appendingPathComponent(thumbnailsDir).appendingPathComponent(filename)
    }
    
    /// Creates thumbnails directory if it doesn't exist — called before any file operations
    private static func ensureThumbnailsDirectory() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("HistoryService: Could not locate Documents directory for thumbnail creation")
            return
        }
        let dirURL = documentsURL.appendingPathComponent(thumbnailsDir)
        guard !FileManager.default.fileExists(atPath: dirURL.path) else { return }
        do {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
            print("HistoryService: Created thumbnails directory at \(dirURL.path)")
        } catch {
            print("HistoryService: Failed to create thumbnails directory: \(error)")
        }
    }
    
    /// Saves a thumbnail image and returns the filename
    @discardableResult
    static func saveThumbnail(image: UIImage, id: UUID) -> String? {
        ensureThumbnailsDirectory()
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("HistoryService: Could not locate Documents directory for thumbnail save")
            return nil
        }
        let filename = "\(id.uuidString).png"
        let fileURL = documentsURL.appendingPathComponent(thumbnailsDir).appendingPathComponent(filename)
        
        guard let data = image.pngData() else {
            print("HistoryService: Failed to encode thumbnail to PNG")
            return nil
        }
        do {
            try data.write(to: fileURL, options: .atomic)
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
