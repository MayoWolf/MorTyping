import Foundation

struct KeyOption: Identifiable, Hashable {
    let keyCode: UInt16
    let label: String

    var id: UInt16 { keyCode }

    static let all: [KeyOption] = {
        var options: [KeyOption] = [
            .init(keyCode: 50, label: "` Backtick"),
            .init(keyCode: 49, label: "Space"),
            .init(keyCode: 36, label: "Return"),
            .init(keyCode: 48, label: "Tab")
        ]

        let letters: [(UInt16, String)] = [
            (0, "A"), (11, "B"), (8, "C"), (2, "D"), (14, "E"), (3, "F"),
            (5, "G"), (4, "H"), (34, "I"), (38, "J"), (40, "K"), (37, "L"),
            (46, "M"), (45, "N"), (31, "O"), (35, "P"), (12, "Q"), (15, "R"),
            (1, "S"), (17, "T"), (32, "U"), (9, "V"), (13, "W"), (7, "X"),
            (16, "Y"), (6, "Z")
        ]

        let numbers: [(UInt16, String)] = [
            (29, "0"), (18, "1"), (19, "2"), (20, "3"), (21, "4"),
            (23, "5"), (22, "6"), (26, "7"), (28, "8"), (25, "9")
        ]

        options += letters.map { .init(keyCode: $0.0, label: $0.1) }
        options += numbers.map { .init(keyCode: $0.0, label: $0.1) }
        return options
    }()

    static func label(for keyCode: UInt16) -> String {
        all.first(where: { $0.keyCode == keyCode })?.label ?? "Key code \(keyCode)"
    }
}
