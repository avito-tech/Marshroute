func marshrouteAssert(
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line) {
    MarshrouteAssertionManager.assert(condition, message, file: file, line: line)
}

func marshrouteAssertionFailure(
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line) {
    MarshrouteAssertionManager.assertionFailure(message, file: file, line: line)
}
