import UIKit

/// Роутер, управляющий одним экраном (одним UINavigationController'ом)
/// Работает с одим обработчиком переходов (detail).
/// Например, роутер обычного экрана iPhone-приложения или роутер экрана внутри UIPopoverController'а
open class BaseRouter:
    TransitionsHandlersProviderHolder,
    TransitionIdGeneratorHolder,
    RouterIdentifiable,
    RouterPresentable,
    RouterTransitionable,
    ModalPresentationRouter,
    PopoverPresentationRouter,
    EndpointRouter,
    RouterFocusable,
    RouterDismissable,
    DetailRouterTransitionable,
    DetailRouter,
    RouterControllersProviderHolder,
    RouterAnimatorsProviderHolder
{
    open let transitionsHandlerBox: RouterTransitionsHandlerBox
    open let transitionId: TransitionId
    open fileprivate(set) weak var presentingTransitionsHandler: TransitionsHandler?
    open let transitionsHandlersProvider: TransitionsHandlersProvider
    open let transitionIdGenerator: TransitionIdGenerator
    open let controllersProvider: RouterControllersProvider
    open let animatorsProvider: RouterAnimatorsProvider
    
    public init(routerSeed: RouterSeed) {
        self.transitionId = routerSeed.transitionId
        self.transitionsHandlerBox = routerSeed.transitionsHandlerBox
        self.presentingTransitionsHandler = routerSeed.presentingTransitionsHandler
        self.transitionsHandlersProvider = routerSeed.transitionsHandlersProvider
        self.transitionIdGenerator = routerSeed.transitionIdGenerator
        self.controllersProvider = routerSeed.controllersProvider
        self.animatorsProvider = routerSeed.animatorsProvider
    }

    // MARK: - DetailRouterTransitionable
    open var detailTransitionsHandlerBox: RouterTransitionsHandlerBox {
        return transitionsHandlerBox
    }
}
