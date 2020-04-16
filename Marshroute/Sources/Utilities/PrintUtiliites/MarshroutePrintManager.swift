public final class MarshroutePrintManager {
    public private(set) static var instance: MarshroutePrintPlugin = DefaultMarshroutePrintPlugin()
    
    public static func setUpPrintPlugin(_ plugin: MarshroutePrintPlugin) {
        instance = plugin
    }
    
    static func print(_ item: Any, separator: String, terminator: String) {
        instance.print(item, separator: separator, terminator: terminator)
    }
}
