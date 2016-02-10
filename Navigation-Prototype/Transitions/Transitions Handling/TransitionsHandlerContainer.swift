protocol TransitionsHandlerContainer: class {
    var allTransitionsHandlers: [TransitionsHandler]? { get }
    var visibleTransitionsHandlers: [TransitionsHandler]? { get }
}