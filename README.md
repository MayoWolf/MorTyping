# MorTyping

MorTyping is a macOS app that types clipboard text character-by-character using a configurable multi-press hotkey.

## For End Users (No Xcode Needed)

1. Download `MorTyping.dmg` from your release.
2. Open the DMG.
3. Drag `MorTyping.app` into `Applications`.
4. Launch `MorTyping`.
5. Approve macOS privacy prompts when asked.

End users do not need Xcode or the Swift toolchain.

## Build a .app and .dmg (Maintainer)

From the project root:

```bash
./scripts/make-dmg.sh
```

Output files:

- `dist/MorTyping.app`
- `dist/MorTyping-macOS.zip`
- `dist/MorTyping.dmg`

## Local Dev Run (Source)

```bash
swift run
```

## Permissions

For global key detection and synthetic typing, macOS may require:

- `Privacy & Security -> Accessibility`
- `Privacy & Security -> Input Monitoring`

## Project Structure

- `Sources/MorTyping/MorTypingApp.swift`: app entry point and scene setup
- `Sources/MorTyping/Models/AppSettings.swift`: persisted app settings
- `Sources/MorTyping/Models/KeyOption.swift`: supported hotkey options
- `Sources/MorTyping/Models/ThemeMode.swift`: appearance mode model
- `Sources/MorTyping/Core/TypingEngine.swift`: global key monitoring + clipboard typing orchestration
- `Sources/MorTyping/Core/InputTyper.swift`: low-level synthetic keystroke typing
- `Sources/MorTyping/UI/ContentView.swift`: main configuration screen
- `scripts/package-app.sh`: build and package standalone `.app` + `.zip`
- `scripts/make-dmg.sh`: create drag-to-Applications DMG
