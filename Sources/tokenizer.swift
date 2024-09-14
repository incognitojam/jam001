import Foundation

enum HTMLToken: Equatable {
    case startTag(String, String)
    case endTag(String)
    case text(String)
}

struct HTMLTokenizer {
    enum HTMLTokenizerError: Swift.Error {
        case unexpectedCharacter(Character)
    }

    private let input: String
    private var currentIndex: String.Index

    init(input: String) {
        self.input = input
        self.currentIndex = input.startIndex
    }

    // Method to check if there are more characters to read
    private func hasMore() -> Bool {
        return currentIndex < input.endIndex
    }

    // Method to look at the next character without advancing
    private func peek() -> Character? {
        return hasMore() ? input[currentIndex] : nil
    }

    // Method to advance to the next character
    private mutating func advance() throws {
        currentIndex = input.index(after: currentIndex)
    }

    // Method to consume characters until a condition is met
    @discardableResult private mutating func readUntil(_ condition: (Character) -> Bool) throws
        -> String
    {
        var result = ""
        while let char = peek(), !condition(char) {
            result.append(char)
            try advance()
        }
        return result
    }

    // Method to consume characters until a given character is found
    @discardableResult private mutating func readUntilChar(_ stopChar: Character) throws -> String {
        return try readUntil({ char in char == stopChar })
    }

    mutating func tokenise() throws -> [HTMLToken] {
        var tokens: [HTMLToken] = []
        while let char = peek() {
            if char == "<" {
                // Process tag
                try advance()  // Skip the '<'

                if let nextChar = peek(), nextChar == "/" {
                    // This is an end tag
                    try advance()  // Skip the '/'
                    let tagName = try readUntilChar(">")
                    try advance()  // Skip the '>'
                    tokens.append(.endTag(tagName))
                } else {
                    // This is a start tag
                    let tagName = try readUntil({ char in char.isWhitespace || char == ">" })
                    if let nextChar = peek(), nextChar.isWhitespace {
                        try readUntil({ char in !char.isWhitespace })  // Skip the whitespace
                        let attributes = try readUntilChar(">")
                        try advance()  // Skip the '>'
                        tokens.append(.startTag(tagName, attributes))
                    } else {
                        // No attributes
                        try advance()  // Skip the '>'
                        tokens.append(.startTag(tagName, ""))
                    }
                }
            } else {
                // Process text outside of tags
                var text = try readUntilChar("<")

                // Trim leading and trailing whitespace
                text = text.trimmingCharacters(in: .whitespacesAndNewlines)

                // Replace all blocks of whitespace, including newlines, with a single space
                text = text.replacingOccurrences(
                    of: "[ \t\r\n]+", with: " ", options: [.regularExpression])

                if !text.isEmpty {
                    tokens.append(.text(text))
                }
            }
        }

        return tokens
    }
}
