import UIKit

/// Роутер, управляющий двумя экранами (двумя UINavigationController'ами)
/// Работает с двумя обработчиками переходов (master и detail).
/// Например, роутер master-контроллера внутри SplitViewController'а
class BaseMasterDetailRouter:
    TransitionsCoordinatorHolder,
    TransitionIdGeneratorHolder,
    RouterIdentifiable,
    RouterPresentable,
    RouterTransitionable,
    Router,
    RouterFocusable,
    RouterDismisable,
    MasterRouterTransitionable,
    MasterRouter,
    DetailRouterTransitionable,
    DetailRouter
{
    let masterTransitionsHandlerBox: RouterTransitionsHandlerBox?
    let detailTransitionsHandlerBox: RouterTransitionsHandlerBox?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(routerSeed seed: BaseMasterDetailRouterSeed)
    {
        self.transitionId = seed.transitionId
        self.masterTransitionsHandlerBox = seed.masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = seed.detailTransitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.transitionsCoordinator = seed.transitionsCoordinator
        self.transitionIdGenerator = seed.transitionIdGenerator
    }

    // MARK: - RouterTransitionable
    var transitionsHandlerBox: RouterTransitionsHandlerBox? {
        return masterTransitionsHandlerBox
    }
}