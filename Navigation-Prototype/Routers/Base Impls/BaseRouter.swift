import UIKit

/// Роутер, управляющий одним экраном (одним UINavigationController'ом)
/// Работает с одим обработчиком переходов (detail).
/// Например, роутер обычного экрана iPhone-приложения или роутер экрана внутри UIPopoverController'а
class BaseRouter:
    TransitionsCoordinatorHolder,
    TransitionIdGeneratorHolder,
    RouterIdentifiable,
    RouterPresentable,
    RouterTransitionable,
    Router,
    RouterFocusable,
    RouterDismisable,
    DetailRouterTransitionable,
    DetailRouter
{
    let transitionsHandlerBox: RouterTransitionsHandlerBox?
    let transitionId: TransitionId
    weak var presentingTransitionsHandler: TransitionsHandler?
    let transitionsCoordinator: TransitionsCoordinator
    let transitionIdGenerator: TransitionIdGenerator
    
    init(routerSeed seed: BaseRouterSeed)
    {
        self.transitionId = seed.transitionId
        self.transitionsHandlerBox = seed.transitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.transitionsCoordinator = seed.transitionsCoordinator
        self.transitionIdGenerator = seed.transitionIdGenerator
    }

    // MARK: - DetailRouterTransitionable
    var detailTransitionsHandlerBox: RouterTransitionsHandlerBox? {
        return transitionsHandlerBox
    }
}