#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MorTyping"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
STAGE_DIR="$DIST_DIR/dmg-staging"
DMG_PATH="$DIST_DIR/$APP_NAME.dmg"
TEMP_DMG="$DIST_DIR/$APP_NAME.temp.dmg"
VOLUME_NAME="$APP_NAME Installer"

"$ROOT_DIR/scripts/package-app.sh"

rm -rf "$STAGE_DIR" "$DMG_PATH" "$TEMP_DMG"
mkdir -p "$STAGE_DIR"

cp -R "$DIST_DIR/$APP_NAME.app" "$STAGE_DIR/$APP_NAME.app"
ln -s /Applications "$STAGE_DIR/Applications"

hdiutil create \
  -volname "$VOLUME_NAME" \
  -srcfolder "$STAGE_DIR" \
  -ov \
  -fs HFS+ \
  -fsargs "-c c=64,a=16,e=16" \
  -format UDRW \
  "$TEMP_DMG"

ATTACH_OUTPUT="$(hdiutil attach -readwrite -noverify -noautoopen "$TEMP_DMG")"
MOUNT_DEV="$(echo "$ATTACH_OUTPUT" | awk '/\/Volumes\// {print $1; exit}')"
MOUNT_DIR="$(echo "$ATTACH_OUTPUT" | awk -F'\t' '/\/Volumes\// {print $NF; exit}')"
MOUNT_NAME="${MOUNT_DIR#/Volumes/}"

if [[ -z "${MOUNT_DEV:-}" || -z "${MOUNT_DIR:-}" ]]; then
  echo "Failed to detect mounted DMG device/path"
  echo "$ATTACH_OUTPUT"
  exit 1
fi

osascript <<EOF
tell application "Finder"
  repeat 30 times
    if exists disk "$MOUNT_NAME" then exit repeat
    delay 0.2
  end repeat
  if not (exists disk "$MOUNT_NAME") then error "Mounted disk not visible in Finder"

  tell disk "$MOUNT_NAME"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set bounds of container window to {120, 120, 780, 500}
    set viewOptions to the icon view options of container window
    set arrangement of viewOptions to not arranged
    set icon size of viewOptions to 128
    set text size of viewOptions to 14
    set shows icon preview of viewOptions to false
    set position of item "$APP_NAME.app" of container window to {180, 190}
    set position of item "Applications" of container window to {480, 190}
    close
    open
    update without registering applications
    delay 1
  end tell
end tell
EOF

hdiutil detach "$MOUNT_DEV"
hdiutil convert "$TEMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$DMG_PATH"
rm -f "$TEMP_DMG"

rm -rf "$STAGE_DIR"

echo "Created: $DMG_PATH"
