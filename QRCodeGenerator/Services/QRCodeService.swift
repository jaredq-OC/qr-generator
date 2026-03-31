import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

/// Pure QR code generation service using native CoreImage
enum QRCodeService {
    /// Generates a QR code image from a string
    /// - Parameters:
    ///   - string: The payload to encode
    ///   - size: Output image size in points (default 300)
    /// - Returns: UIImage of the QR code, or nil if generation fails
    static func generateQRImage(from string: String, size: CGFloat = 300) -> UIImage? {
        guard !string.isEmpty else { return nil }
        
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        
        guard let ciImage = filter.outputImage else { return nil }
        
        // Scale without blur
        let scaleX = size / ciImage.extent.width
        let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Generates a thumbnail-sized QR code (100x100)
    static func generateThumbnail(from string: String) -> UIImage? {
        return generateQRImage(from: string, size: 100)
    }
}
