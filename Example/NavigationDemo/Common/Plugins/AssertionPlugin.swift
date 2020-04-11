import Marshroute

final class DemoAssertionPlugin: MarshrouteAssertionPlugin {
    private let demoPrefix = "[NavigatonDemo]"
    
    func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt)
    {
        if !condition() {
            print("\(demoPrefix) \(message()) file: \(file), line: \(line)")
        }
    }
    
    func assertionFailure(
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt)
    {
        print("\(demoPrefix) \(message()) file: \(file), line: \(line)")
    }
}
