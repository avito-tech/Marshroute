func marshrouteAssert(
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line) {
    MarshrouteAssertionManager.assert(condition, message, file: file, line: line)
}
