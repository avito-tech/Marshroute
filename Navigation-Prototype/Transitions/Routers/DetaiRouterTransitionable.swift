protocol DetailRouterTransitionable: class {
    /// слабая ссылка на обработчика переходов
    weak var detailTransitionsHandler: TransitionsHandler? { get }
}