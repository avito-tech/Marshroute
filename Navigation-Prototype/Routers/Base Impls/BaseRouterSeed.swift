import Foundation

/// Параметры для создания роутеров, управляющих одним экраном (одним UINavigationController'ом)
struct BaseRouterSeed {
    let transitionsHandlerBox: RouterTransitionsHandlerBox
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
}