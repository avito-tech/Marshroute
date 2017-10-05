public protocol MarshroutePrintPlugin {
    func print(_ item: Any, separator: String, terminator: String)
    func debugPrint(_ item: Any, separator: String, terminator: String)
}

final class DefaultMarshroutePrintPlugin: MarshroutePrintPlugin {
    func print(_ item: Any, separator: String, terminator: String) {
        print(item, separator: separator, terminator: terminator)
    }
    
    func debugPrint(_ item: Any, separator: String, terminator: String) {
        debugPrint(item, separator: separator, terminator: terminator)
    }
}
