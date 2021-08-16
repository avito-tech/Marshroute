public protocol DetailRouterTransitionable: AnyObject {
    /// ссылка на обработчика переходов
    var detailTransitionsHandlerBox: RouterTransitionsHandlerBox { get }
}
