public protocol RouterIdentifiable: class {
    /// идентификатор перехода на модуль роутера
    var transitionId: TransitionId { get }
}
