import Foundation

/// Роутер для master контроллера внутри SplitViewController'а
/// Работаюет с двумя обработчиками переходов (master и detail)
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
    
    init(routerSeed seed: BaseRouterSeed,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox)
    {
        self.transitionId = seed.transitionId
        self.masterTransitionsHandlerBox = seed.transitionsHandlerBox
        self.detailTransitionsHandlerBox = detailTransitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.transitionsCoordinator = seed.transitionsCoordinator
        self.transitionIdGenerator = seed.transitionIdGenerator
    }

    // MARK: - RouterTransitionable
    var transitionsHandlerBox: RouterTransitionsHandlerBox? {
        return masterTransitionsHandlerBox
    }
}