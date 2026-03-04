import AppKit
@preconcurrency import ApplicationServices

@MainActor
final class TypingEngine: ObservableObject {
    @Published var statusMessage: String = "Ready"
    @Published var accessibilityGranted: Bool = AXIsProcessTrusted()

    private let settings: AppSettings
    private let typer = InputTyper()

    private var globalMonitor: Any?
    private var recentTaps: [TimeInterval] = []

    init(settings: AppSettings) {
        self.settings = settings
    }

    func start() {
        guard globalMonitor == nil else { return }

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            Task { @MainActor in
                self?.handleKeyDown(event)
            }
        }

        statusMessage = listeningMessage
    }

    func refreshListeningMessage() {
        statusMessage = listeningMessage
    }

    func requestAccessibilityPermission() {
        let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options = [promptKey: true] as CFDictionary
        accessibilityGranted = AXIsProcessTrustedWithOptions(options)
        if !accessibilityGranted {
            statusMessage = "Accessibility not granted yet"
        }
    }

    func refreshPermissionState() {
        accessibilityGranted = AXIsProcessTrusted()
    }

    func typeClipboardNow() {
        guard accessibilityGranted else {
            statusMessage = "Grant Accessibility first"
            NSSound.beep()
            return
        }

        guard let clipboardText = NSPasteboard.general.string(forType: .string), !clipboardText.isEmpty else {
            statusMessage = "Clipboard is empty"
            NSSound.beep()
            return
        }

        let delayUs = useconds_t(max(1.0, settings.typingDelayMs) * 1000.0)
        statusMessage = "Typing \(clipboardText.count) characters..."

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.typer.typeText(clipboardText, delayMicroseconds: delayUs)
            Task { @MainActor in
                self?.statusMessage = "Done"
            }
        }
    }

    private var listeningMessage: String {
        "Listening for \(settings.tapCount)x \(KeyOption.label(for: settings.hotKeyCode))"
    }

    private func handleKeyDown(_ event: NSEvent) {
        guard event.keyCode == settings.hotKeyCode else { return }
        guard event.modifierFlags.intersection(.deviceIndependentFlagsMask).isEmpty else { return }

        let now = Date().timeIntervalSinceReferenceDate
        recentTaps.append(now)
        recentTaps = recentTaps.filter { now - $0 <= settings.tapWindow }

        if recentTaps.count >= settings.tapCount {
            recentTaps.removeAll()
            typeClipboardNow()
        }
    }
}
