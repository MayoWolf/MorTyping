# MorTyping

MorTyping is a macOS SwiftUI app that types clipboard text character-by-character, triggered by a configurable multi-press hotkey.

## Features

- Liquid glass-inspired UI with teal accent styling
- Theme mode selection: `System`, `Light`, `Dark`
- Configurable hotkey
- Configurable required press count (multi-tap)
- Configurable multi-tap timing window
- Configurable per-character typing delay
- Manual `Type Clipboard Now` action
- Global key listening while the app is open

## Requirements

- macOS 13+
- Xcode / Swift toolchain with Swift 6.2

## Run

```bash
cd /Users/wolfnazari/MorTyping
swift run
```

## Permissions

For global key detection and synthetic typing:

- `System Settings -> Privacy & Security -> Accessibility`
- `System Settings -> Privacy & Security -> Input Monitoring`

If behavior does not start immediately after granting permissions, quit and relaunch the app.

## Project Structure

- `Sources/MorTyping/MorTypingApp.swift`: app entry point and scene setup
- `Sources/MorTyping/Models/AppSettings.swift`: persisted app settings
- `Sources/MorTyping/Models/KeyOption.swift`: supported hotkey options
- `Sources/MorTyping/Models/ThemeMode.swift`: appearance mode model
- `Sources/MorTyping/Core/TypingEngine.swift`: global key monitoring + clipboard typing orchestration
- `Sources/MorTyping/Core/InputTyper.swift`: low-level synthetic keystroke typing
- `Sources/MorTyping/UI/ContentView.swift`: main configuration screen
- `Sources/MorTyping/UI/GlassStyle.swift`: reusable liquid glass background and cards
# MorTyping
