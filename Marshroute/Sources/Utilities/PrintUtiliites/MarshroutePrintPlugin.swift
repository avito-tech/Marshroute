public protocol MarshroutePrintPlugin: AnyObject {
    func print(_ item: Any, separator: String, terminator: String)
    func debugPrint(_ item: Any, separator: String, terminator: String)
}

public final class DefaultMarshroutePrintPlugin: MarshroutePrintPlugin {
    public init() {}
    
    public func print(_ item: Any, separator: String, terminator: String) {
        Swift.print(item, separator: separator, terminator: terminator)
    }
    
    public func debugPrint(_ item: Any, separator: String, terminator: String) {
        Swift.debugPrint(item, separator: separator, terminator: terminator)
    }
}
