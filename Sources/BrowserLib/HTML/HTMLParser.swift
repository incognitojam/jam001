public struct HTMLParser {
    enum HTMLParserError: Swift.Error {
        case unexpectedToken(HTMLToken)
    }

    private var tokens: Array<HTMLToken>.Iterator

    public init(tokens: [HTMLToken]) {
        self.tokens = tokens.makeIterator()
    }

    /// Parse the HTML tokens into a tree of HTML nodes
    public mutating func parse() throws -> HTMLDocument {
        var stack: [(element: HTMLNode, tagName: String)] = []
        stack.append((.element("HTML", attributes: "", children: []), "HTML"))

        while let token = tokens.next() {
            print("Token: \(token)")

            switch token {
            case .startTag(let tagName, let attributes):
                // Create a new element node and push it onto the stack
                let node = HTMLNode.element(tagName, attributes: attributes, children: [])
                stack.append((node, tagName))

            case .endTag(let tagName):
                // Search the stack for a matching start tag
                if let index = stack.lastIndex(where: { $0.tagName == tagName }) {
                    // Pop each node from the stack until we find the matching node
                    var currentNode: (element: HTMLNode, tagName: String)?

                    while stack.count > index {
                        // FIXME: We should close all unclosed tags here instead of just the one we are looking for
                        currentNode = stack.popLast()
                        if currentNode?.tagName == tagName {
                            break
                        }
                    }

                    if let node = currentNode {
                        // Add the completed node to its parent's children
                        if var (parentNode, _) = stack.last,
                            case var .element(parentTagName, parentAttributes, parentChildren) =
                                parentNode
                        {
                            parentChildren.append(node.element)
                            stack[stack.count - 1].element = .element(
                                parentTagName, attributes: parentAttributes,
                                children: parentChildren
                            )
                        }
                    }
                } else {
                    // If no matching tag is found, this is an extaneous end tag
                    print("WARNING: Extraneous end tag </\(tagName)>")
                }

            case .text(let text):
                // Create a text node and add it to the current node on the stack
                let node = HTMLNode.text(text)
                if var (currentNode, tagName) = stack.last,
                    case var .element(currentTagName, currentAttributes, currentChildren) =
                        currentNode
                {
                    currentChildren.append(node)
                    stack[stack.count - 1].element = .element(
                        currentTagName, attributes: currentAttributes, children: currentChildren
                    )
                }
            }

            print("Out Stack: \(stack)")
            print()
        }

        if stack.count > 1 {
            print("WARNING: Stack is not empty at the end of parsing")
        }

        return HTMLDocument(root: stack.first!.element)
    }
}
