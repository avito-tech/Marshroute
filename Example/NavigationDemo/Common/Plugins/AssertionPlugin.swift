import Marshroute

final class DemoAssertionPlugin: MarshrouteAssertionPlugin {
    private let demoPrefix = "NavigatonDemo "
    
    func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt) {
        let demoMessage = demoPrefix + message()
        Swift.assert(condition(), demoMessage, file: file, line: line)
    }
    
    func assertionFailure(
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt) {
        let demoMessage = demoPrefix + message()
        Swift.assertionFailure(demoMessage, file: file, line: line)
    }
}
