public protocol TransitionIdGenerator: class {
    /// Геренирует новый псевдослучайный уникальный идентификатор перехода
    func generateNewTransitionId() -> TransitionId
}
