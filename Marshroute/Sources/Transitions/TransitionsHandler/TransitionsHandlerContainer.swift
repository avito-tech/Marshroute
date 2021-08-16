public protocol TransitionsHandlerContainer: AnyObject {
    var allTransitionsHandlers: [AnimatingTransitionsHandler]? { get }
    var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? { get }
}
