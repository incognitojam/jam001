// Welcome to Browser Jam #001! 🚀
// Since this is the first-ever Browser Jam, your challenge will be to build a browser from scratch
// that can render the first-ever website: http://info.cern.ch/hypertext/WWW/TheProject.html.

// The source is saved in the file `challenge.html` in this repository.

// Code to write:
// - HTML tokenizer and parser (construct tree)
// - Create window/OpenGL context
// - Render the tree
// - ???
// - Profit

import Foundation

struct FileLoader {
    enum Error: Swift.Error {
        case fileNotFound(path: String)
        case failedToLoadData(path: String, Swift.Error)
    }

    static func load(path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let html = String(data: data, encoding: .utf8)
            if html == nil {
                throw Error.fileNotFound(path: path)
            }
            return html!
        } catch {
            throw Error.failedToLoadData(path: path, error)
        }
    }
}

struct AppArguments {
    var path: String

    init() {
        let defaults = UserDefaults.standard
        self.path = defaults.string(forKey: "path") ?? "challenge.html"
    }
}

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

    // Method to consume characters until a given character is found
    private mutating func readUntilChar(_ stopChar: Character) throws -> String {
        var result = ""
        while let char = peek(), char != stopChar {
            result.append(char)
            try advance()
        }
        return result
    }

    // Method to consume characters until a condition is met
    private mutating func readUntil(_ condition: (Character) -> Bool) throws -> String {
        var result = ""
        while let char = peek(), !condition(char) {
            result.append(char)
            try advance()
        }
        return result
    }

    mutating func tokenise() throws -> [HTMLToken] {
        var tokens: [HTMLToken] = []
        while let char = peek() {
            if char == "<" {
                // Process tag
                print("<", terminator: "")
                try advance()  // Skip the '<'

                if let nextChar = peek(), nextChar == "/" {
                    // This is an end tag
                    try advance()  // Skip the '/'
                    let tagName = try readUntilChar(">")
                    print(tagName, terminator: "")
                    try advance()  // Skip the '>'
                    print(">", terminator: "")
                    tokens.append(.endTag(tagName))
                } else {
                    // This is a start tag
                    let tagName = try readUntil({ char in char == " " || char == ">" })
                    print(tagName, terminator: "")
                    if let nextChar = peek(), nextChar == " " {
                        try advance()  // Skip the ' '
                        let attributes = try readUntilChar(">")
                        print(attributes, terminator: "")
                        try advance()  // Skip the '>'
                        print(">", terminator: "")
                        tokens.append(.startTag(tagName, attributes))
                    } else {
                        // No attributes
                        try advance()  // Skip the '>'
                        print(">", terminator: "")
                        tokens.append(.startTag(tagName, ""))
                    }
                }
            } else {
                // Process text outside of tags
                let text = try readUntilChar("<")
                if !text.isEmpty {
                    tokens.append(.text(text))
                }
                print(text, terminator: "")
            }
        }

        return tokens
    }
}

let args = AppArguments()
let html = try FileLoader.load(path: args.path)
//print(html)

var tokenizer = HTMLTokenizer(input: html)
let tokens = try tokenizer.tokenise()
print(tokens)
