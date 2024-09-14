public enum HTMLToken: Equatable {
    case startTag(String, String)
    case endTag(String)
    case text(String)
}
