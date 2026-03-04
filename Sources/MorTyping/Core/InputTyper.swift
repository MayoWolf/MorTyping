import Foundation
import CoreGraphics

struct InputTyper {
    func typeText(_ text: String, delayMicroseconds: useconds_t) {
        for scalar in text.unicodeScalars {
            let value = UInt16(scalar.value)

            guard let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true),
                  let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) else {
                continue
            }

            keyDown.keyboardSetUnicodeString(stringLength: 1, unicodeString: [value])
            keyUp.keyboardSetUnicodeString(stringLength: 1, unicodeString: [value])
            keyDown.post(tap: .cghidEventTap)
            keyUp.post(tap: .cghidEventTap)

            usleep(delayMicroseconds)
        }
    }
}
