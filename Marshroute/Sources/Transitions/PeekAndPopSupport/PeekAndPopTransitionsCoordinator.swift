public protocol PeekAndPopTransitionsCoordinator: class {
    func coordinatePeekIfNeededFor(
        viewController: UIViewController,
        popAction: @escaping (() -> ()))
}
