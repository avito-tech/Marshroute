import Marshroute

final class DemoPrintPlugin: MarshroutePrintPlugin {
    private let demoPrefix = "NavigatonDemo:"
    
    func print(_ item: Any, separator: String, terminator: String) {
        Swift.print(demoPrefix, item, separator: separator, terminator: terminator)
    }
    
    func debugPrint(_ item: Any, separator: String, terminator: String) {
        Swift.debugPrint(demoPrefix, item, separator: separator, terminator: terminator)
    }
}
