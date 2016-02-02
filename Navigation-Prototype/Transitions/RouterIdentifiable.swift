import Foundation

protocol RouterIdentifiable: class {
    /// идентификатор перехода на роутер
    var transitionId: TransitionId { get }
}
