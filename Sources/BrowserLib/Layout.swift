import Raylib

// TODO: support x positioning/width
public struct LayoutContext {
    public let screenWidth: Float
    public var y: Float

    public init(screenWidth: Float, y: Float = 0.0) {
        self.screenWidth = screenWidth
        self.y = y
    }

    public func with(screenWidth: Float? = nil, y: Float? = nil) -> LayoutContext {
        LayoutContext(screenWidth: screenWidth ?? self.screenWidth, y: y ?? self.y)
    }
}

/// Represents the layout of each element
public struct LayoutBox {
    let node: HTMLNode
    let children: [LayoutBox]
    let x: Float
    let y: Float
    let width: Float
    let height: Float
}

public struct LayoutEngine {
    let font: Font

    public init(_ font: Font) {
        self.font = font
    }

    /// Traverse the HTML tree and generate the layout tree
    public func layout(node: HTMLNode, in context: LayoutContext) -> LayoutBox {
        switch node {
        case .element(_, _, let children):
            var height: Float = 1.0
            let childrenLayout: [LayoutBox] = children.map { child in
                let childLayout = layout(node: child, in: context.with(y: context.y + height))
                height += childLayout.height
                return childLayout
            }
            height += 1.0
            return LayoutBox(
                node: node, children: childrenLayout, x: 0, y: context.y,
                width: context.screenWidth, height: height)

        case .text(let text):
            let height = text.withCString {
                let bounds = MeasureTextEx(font, $0, 24, 1)
                print("\(text) bounds: \(bounds)")
                return bounds.y
            }
            return LayoutBox(
                node: node, children: [], x: 0, y: context.y,
                width: context.screenWidth, height: height)
        }
    }
}
