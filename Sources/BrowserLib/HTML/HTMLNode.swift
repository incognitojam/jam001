public enum HTMLNode {
    case element(_ tagName: String, attributes: String, children: [HTMLNode])
    case text(String)
}
