public final class MarshroutePrintManager {
    private static var sharedInstance: MarshroutePrintPlugin = DefaultMarshroutePrintPlugin()
    
    public static func setupPrintPlugin(_ plugin: MarshroutePrintPlugin) {
        sharedInstance = plugin
    }
    
    static func print(_ item: Any, separator: String, terminator: String) {
        sharedInstance.print(item, separator: separator, terminator: terminator)
    }
    
    static func debugPrint(_ item: Any, separator: String, terminator: String) {
        sharedInstance.print(item, separator: separator, terminator: terminator)
    }
}
