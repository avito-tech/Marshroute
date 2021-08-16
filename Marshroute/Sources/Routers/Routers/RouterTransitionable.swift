public protocol RouterTransitionable: AnyObject {
    /// обработчик переходов роутера
    var transitionsHandlerBox: RouterTransitionsHandlerBox { get }
}
