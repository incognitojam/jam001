import Raylib

// TODO: support x positioning/width
public struct LayoutContext {
    var y: Float

    public init(y: Float) {
        self.y = y
    }
}

/// Represents the layout of each element
public struct LayoutBox {
    let node: HTMLNode
    let y: Float
    let height: Float
    let children: [LayoutBox]
}

public struct LayoutEngine {
    public init() {
    }

    /// Traverse the HTML tree and generate the layout tree
    public func layout(node: HTMLNode, in context: LayoutContext) -> LayoutBox {
        switch node {
        case .element(_, _, let children):
            var height: Float = 1.0
            let childrenLayout: [LayoutBox] = children.map { child in
                let childLayout = layout(node: child, in: LayoutContext(y: context.y + height))
                height += childLayout.height
                return childLayout
            }
            height += 1.0
            return LayoutBox(node: node, y: context.y, height: height, children: childrenLayout)

        case .text(_):
            // let font = GetFontDefault()
            // let height = text.withCString {
            //     let bounds = MeasureTextEx(font, $0, 24, 1)
            //     print("\(text) bounds: \(bounds)")
            //     return bounds.y
            // }
            let height: Float = 10  // default font
            return LayoutBox(node: node, y: context.y, height: height, children: [])
        }
    }
}
