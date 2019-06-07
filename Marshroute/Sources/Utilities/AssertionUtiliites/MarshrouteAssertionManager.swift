public final class MarshrouteAssertionManager {
    private static var instance: MarshrouteAssertionPlugin = DefaultMarshrouteAssertionPlugin()
    
    public static func setUpAssertionPlugin(_ plugin: MarshrouteAssertionPlugin) {
        instance = plugin
    }
    
    static func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt) {
        instance.assert(condition(), message(), file: file, line: line)
    }
    
    static func assertionFailure(
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt) {
        instance.assertionFailure(message(), file: file, line: line)
    }
}
