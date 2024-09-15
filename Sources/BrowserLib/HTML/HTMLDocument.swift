public struct HTMLDocument {
    public let root: HTMLNode
}

/// Recursively renders an HTML node as a string
func printTree(_ node: HTMLNode, level: Int = 0) -> String {
    let indent = String(repeating: " ", count: level * 2)
    var builder = ""

    switch node {
    case .element(let tagName, let attributes, let children):
        builder += "\(indent)<\(tagName)\(attributes.isEmpty ? "" : " \(attributes)")>\n"
        for child in children {
            builder += printTree(child, level: level + 1)
        }

    case .text(let text):
        builder += "\(indent)\(text)\n"
    }

    return builder
}

extension HTMLDocument: CustomStringConvertible {
    public var description: String {
        "HTMLDocument(root: \n\(printTree(root)))"
    }
}
