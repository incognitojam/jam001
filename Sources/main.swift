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

enum Token: Equatable {
    case startTag(String)
    case endTag(String)
    case character(Character)
}

struct Tokenizer {
    private let source: String
    private var index: String.Index

    init(source: String) {
        self.source = source
        self.index = source.startIndex
    }

    private func peek() -> Character? {
        return self.source[self.index]
    }
    private mutating func take() -> Character? {
        let character = self.source[self.index]
        self.index = self.source.index(after: self.index)
        return character
    }
}

let args = AppArguments()
let html = try FileLoader.load(path: args.path)
print(html)
