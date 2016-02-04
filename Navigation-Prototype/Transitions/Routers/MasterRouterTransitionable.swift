protocol MasterRouterTransitionable: class {
    /// слабая ссылка на обработчика переходов
    unowned var masterTransitionsHandler: TransitionsHandler { get }
}