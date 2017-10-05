public protocol MarshrouteAssertionPlugin {
    func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt)
}

final class DefaultMarshrouteAssertionPlugin: MarshrouteAssertionPlugin {
    func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> String,
        file: StaticString,
        line: UInt) {
        Swift.assert(condition, message, file: file, line: line)
    }
}
