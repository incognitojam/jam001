// Welcome to Browser Jam #001! 🚀
// Since this is the first-ever Browser Jam, your challenge will be to build a browser from scratch
// that can render the first-ever website: http://info.cern.ch/hypertext/WWW/TheProject.html.

// The source is saved in the file `challenge.html` in this repository.

// Code to write:
// - HTML parser
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

let args = AppArguments()

do {
    let html = try FileLoader.load(path: args.path)
    print(html)
} catch {
    print("Error: \(error)")
}
