public enum HTMLToken: Equatable, Sendable {
    case startTag(String, String)
    case endTag(String)
    case text(String)
}
