import SwiftUI

struct ContentView: View {
    @ObservedObject var settings: AppSettings
    @ObservedObject var engine: TypingEngine

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("Trigger") {
                    Picker("Hot key", selection: $settings.hotKeyCode) {
                        ForEach(KeyOption.all) { option in
                            Text(option.label).tag(option.keyCode)
                        }
                    }

                    Stepper("Press count", value: $settings.tapCount, in: 2...8)

                    HStack {
                        Text("Timing window")
                        Slider(value: $settings.tapWindow, in: 0.3...1.6, step: 0.05)
                        Text(String(format: "%.2fs", settings.tapWindow))
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Typing") {
                    HStack {
                        Text("Character delay")
                        Slider(value: $settings.typingDelayMs, in: 1...60, step: 1)
                        Text("\(Int(settings.typingDelayMs))ms")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }

                    Button("Type Clipboard Now") {
                        engine.typeClipboardNow()
                    }
                }

                Section("Appearance") {
                    Picker("Mode", selection: $settings.themeModeRaw) {
                        ForEach(ThemeMode.allCases) { mode in
                            Text(mode.title).tag(mode.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)                }

                Section("Permissions") {
                    Text(engine.accessibilityGranted ? "Accessibility: Granted" : "Accessibility: Not granted")
                        .foregroundStyle(engine.accessibilityGranted ? .green : .orange)

                    HStack {
                        Button("Request Accessibility") {
                            engine.requestAccessibilityPermission()
                        }

                        Button("Refresh") {
                            engine.refreshPermissionState()
                        }
                    }
                }
            }

            HStack {
                Circle()
                    .fill(engine.accessibilityGranted ? Color.green : Color.orange)
                    .frame(width: 8, height: 8)
                Text(engine.statusMessage)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.bar)
        }
        .onChange(of: settings.hotKeyCode) { _ in engine.refreshListeningMessage() }
        .onChange(of: settings.tapCount) { _ in engine.refreshListeningMessage() }
    }
}
