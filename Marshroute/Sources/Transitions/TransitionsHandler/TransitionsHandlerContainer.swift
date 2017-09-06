public protocol TransitionsHandlerContainer: class {
    var allTransitionsHandlers: [AnimatingTransitionsHandler]? { get }
    var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? { get }
}
