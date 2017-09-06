public protocol RouterTransitionable: class {
    /// обработчик переходов роутера
    var transitionsHandlerBox: RouterTransitionsHandlerBox { get }
}
