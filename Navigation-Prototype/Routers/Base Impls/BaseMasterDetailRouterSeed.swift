import Foundation

/// Параметры для создания роутеров, управляющих двумя экранами (двумя UINavigationController'ами)
struct BaseMasterDetailRouterSeed {
    let masterTransitionsHandlerBox: RouterTransitionsHandlerBox
    let detailTransitionsHandlerBox: RouterTransitionsHandlerBox
    let transitionId: TransitionId
    let presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
}