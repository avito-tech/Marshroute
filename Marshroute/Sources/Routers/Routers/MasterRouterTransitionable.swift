public protocol MasterRouterTransitionable: class {
    /// ссылка на обработчика переходов
    var masterTransitionsHandlerBox: RouterTransitionsHandlerBox { get }
}
