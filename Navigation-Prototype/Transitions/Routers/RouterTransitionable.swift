protocol RouterTransitionable: class {
    /// слабая ссылка на обработчика переходов из роутера
    weak var transitionsHandler: TransitionsHandler? { get }
}