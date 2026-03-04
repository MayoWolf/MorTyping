#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MorTyping"
BUNDLE_ID="com.mayowolf.mortyping"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
ICON_SOURCE="$ROOT_DIR/assets/AppIcon-1024.png"
ICONSET_DIR="$DIST_DIR/AppIcon.iconset"
ICON_ICNS="$DIST_DIR/AppIcon.icns"
ICON_PLIST_FRAGMENT=""

mkdir -p "$DIST_DIR"
rm -rf "$APP_DIR" "$DIST_DIR/$APP_NAME-macOS.zip" "$ICONSET_DIR" "$ICON_ICNS"

(
  cd "$ROOT_DIR"
  swift build -c release >/dev/null
)

BIN_DIR="$(cd "$ROOT_DIR" && swift build -c release --show-bin-path)"
BIN_PATH="$BIN_DIR/$APP_NAME"

mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cp "$BIN_PATH" "$APP_DIR/Contents/MacOS/$APP_NAME"

# Build .icns if an icon source PNG exists.
if [[ -f "$ICON_SOURCE" ]]; then
  mkdir -p "$ICONSET_DIR"
  for size in 16 32 64 128 256 512; do
    sips -z "$size" "$size" "$ICON_SOURCE" --out "$ICONSET_DIR/icon_${size}x${size}.png" >/dev/null
    sips -z "$((size * 2))" "$((size * 2))" "$ICON_SOURCE" --out "$ICONSET_DIR/icon_${size}x${size}@2x.png" >/dev/null
  done
  iconutil -c icns "$ICONSET_DIR" -o "$ICON_ICNS"
  cp "$ICON_ICNS" "$APP_DIR/Contents/Resources/AppIcon.icns"
  ICON_PLIST_FRAGMENT=$'  <key>CFBundleIconFile</key>\n  <string>AppIcon</string>'
else
  echo "WARNING: Missing icon source at $ICON_SOURCE"
  echo "Using default app icon."
fi

cat > "$APP_DIR/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
${ICON_PLIST_FRAGMENT}
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>13.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

# Ad-hoc sign to make local launch behavior smoother.
codesign --force --deep --sign - "$APP_DIR"

(
  cd "$DIST_DIR"
  ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" "$APP_NAME-macOS.zip"
)

echo "Created: $DIST_DIR/$APP_NAME-macOS.zip"
