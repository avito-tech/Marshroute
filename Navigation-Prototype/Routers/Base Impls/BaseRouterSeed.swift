import Foundation

/// Параметры для создания роутеров
struct BaseRouterSeed {
    let transitionsHandlerBox: RouterTransitionsHandlerBox
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
}