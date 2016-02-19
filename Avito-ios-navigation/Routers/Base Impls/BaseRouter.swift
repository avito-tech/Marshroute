import UIKit

/// Роутер, управляющий одним экраном (одним UINavigationController'ом)
/// Работает с одим обработчиком переходов (detail).
/// Например, роутер обычного экрана iPhone-приложения или роутер экрана внутри UIPopoverController'а
public class BaseRouter:
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
    public let transitionsHandlerBox: RouterTransitionsHandlerBox?
    public let transitionId: TransitionId
    public private (set) weak var presentingTransitionsHandler: TransitionsHandler?
    public let transitionsCoordinator: TransitionsCoordinator
    public let transitionIdGenerator: TransitionIdGenerator
    
    public init(routerSeed seed: RouterSeed)
    {
        self.transitionId = seed.transitionId
        self.transitionsHandlerBox = seed.transitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.transitionsCoordinator = seed.transitionsCoordinator
        self.transitionIdGenerator = seed.transitionIdGenerator
    }

    // MARK: - DetailRouterTransitionable
    public var detailTransitionsHandlerBox: RouterTransitionsHandlerBox? {
        return transitionsHandlerBox
    }
}