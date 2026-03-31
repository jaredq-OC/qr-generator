import SwiftUI

@main
struct QRCodeGeneratorApp: App {
    @AppStorage("appearanceMode") private var appearanceMode: String = "system"
    
    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
    
    var body: some Scene {
        WindowGroup {
            GeneratorView()
                .preferredColorScheme(colorScheme)
        }
    }
}
