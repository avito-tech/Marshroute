public protocol MarshroutePrintPlugin: AnyObject {
    func print(_ item: Any, separator: String, terminator: String)
}

public final class DefaultMarshroutePrintPlugin: MarshroutePrintPlugin {
    public init() {}
    
    public func print(_ item: Any, separator: String, terminator: String) {
        Swift.print(item, separator: separator, terminator: terminator)
    }
}
