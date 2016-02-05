protocol MasterRouterTransitionable: class {
    /// слабая ссылка на обработчика переходов
    weak var masterTransitionsHandler: TransitionsHandler? { get }
}