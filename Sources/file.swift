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
