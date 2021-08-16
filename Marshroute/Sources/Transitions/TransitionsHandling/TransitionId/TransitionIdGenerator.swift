public protocol TransitionIdGenerator: AnyObject {
    /// Геренирует новый псевдослучайный уникальный идентификатор перехода
    func generateNewTransitionId() -> TransitionId
}
