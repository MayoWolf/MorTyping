import SwiftUI

@main
struct MorTypingApp: App {
    @StateObject private var settings: AppSettings
    @StateObject private var engine: TypingEngine

    init() {
        let settings = AppSettings()
        _settings = StateObject(wrappedValue: settings)
        _engine = StateObject(wrappedValue: TypingEngine(settings: settings))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(settings: settings, engine: engine)
                .preferredColorScheme(settings.themeMode.colorScheme)
                .onAppear {
                    engine.requestAccessibilityPermission()
                    engine.start()
                }
        }
        .defaultSize(width: AppSettings.baseWindowWidth, height: AppSettings.baseWindowHeight)
        .windowResizability(.contentSize)
    }
}
