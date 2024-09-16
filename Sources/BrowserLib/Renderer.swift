public enum RenderCommand {
    case drawRect(x: Float, y: Float, width: Float, height: Float)
    case drawText(x: Float, y: Float, text: String)
}

public struct Renderer {
    public init() {}

    /// Render the layout tree into drawing commands
    public func render(layout: LayoutBox) -> [RenderCommand] {
        var commands: [RenderCommand] = []

        switch layout.node {
        case .element(_, _, _):
            commands.append(
                .drawRect(x: layout.x, y: layout.y, width: layout.width, height: layout.height))
            for child in layout.children {
                commands += render(layout: child)
            }

        case .text(let text):
            commands.append(.drawText(x: layout.x, y: layout.y, text: text))
        }

        return commands
    }
}
