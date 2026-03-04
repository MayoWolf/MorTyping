import Foundation
import SwiftUI

@MainActor
final class AppSettings: ObservableObject {
    private enum Keys {
        static let hotKeyCode = "hotKeyCode"
        static let tapCount = "tapCount"
        static let tapWindow = "tapWindow"
        static let typingDelayMs = "typingDelayMs"
        static let themeMode = "themeModeRaw"
    }

    static let baseWindowWidth: CGFloat = 560
    static let baseWindowHeight: CGFloat = 800

    @Published var hotKeyCode: UInt16 {
        didSet { UserDefaults.standard.set(Int(hotKeyCode), forKey: Keys.hotKeyCode) }
    }

    @Published var tapCount: Int {
        didSet { UserDefaults.standard.set(tapCount, forKey: Keys.tapCount) }
    }

    @Published var tapWindow: Double {
        didSet { UserDefaults.standard.set(tapWindow, forKey: Keys.tapWindow) }
    }

    @Published var typingDelayMs: Double {
        didSet { UserDefaults.standard.set(typingDelayMs, forKey: Keys.typingDelayMs) }
    }

    @Published var themeModeRaw: String {
        didSet { UserDefaults.standard.set(themeModeRaw, forKey: Keys.themeMode) }
    }

    init() {
        let defaults = UserDefaults.standard
        let keyCode = defaults.integer(forKey: Keys.hotKeyCode)
        let savedTapCount = defaults.integer(forKey: Keys.tapCount)
        let savedDelay = defaults.double(forKey: Keys.typingDelayMs)
        let savedTapWindow = defaults.double(forKey: Keys.tapWindow)

        hotKeyCode = keyCode == 0 ? 50 : UInt16(keyCode)
        tapCount = savedTapCount == 0 ? 3 : savedTapCount
        typingDelayMs = savedDelay == 0 ? 12 : savedDelay
        tapWindow = savedTapWindow == 0 ? 0.7 : savedTapWindow
        themeModeRaw = defaults.string(forKey: Keys.themeMode) ?? ThemeMode.system.rawValue
    }

    var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeRaw) ?? .system
    }

    var windowWidth: CGFloat { Self.baseWindowWidth }
    var windowHeight: CGFloat { Self.baseWindowHeight }
}
