public protocol MasterRouterTransitionable: AnyObject {
    /// ссылка на обработчика переходов
    var masterTransitionsHandlerBox: RouterTransitionsHandlerBox { get }
}
