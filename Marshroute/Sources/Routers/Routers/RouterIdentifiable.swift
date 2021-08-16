public protocol RouterIdentifiable: AnyObject {
    /// идентификатор перехода на модуль роутера
    var transitionId: TransitionId { get }
}
