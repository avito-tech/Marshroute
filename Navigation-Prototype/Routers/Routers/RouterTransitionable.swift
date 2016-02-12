protocol RouterTransitionable: class {
    /// ссылка на обработчика переходов
    var transitionsHandlerBox: RouterTransitionsHandlerBox? { get }
}