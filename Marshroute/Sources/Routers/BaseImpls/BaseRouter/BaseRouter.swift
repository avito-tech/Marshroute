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
    RouterTransitionDelegateHoder
{
    public let transitionsHandlerBox: RouterTransitionsHandlerBox
    public let transitionId: TransitionId
    open fileprivate(set) weak var presentingTransitionsHandler: TransitionsHandler?
    open fileprivate(set) weak var routerTransitionDelegate: RouterTransitionDelegate?
    public let transitionsHandlersProvider: TransitionsHandlersProvider
    public let transitionIdGenerator: TransitionIdGenerator
    public let controllersProvider: RouterControllersProvider
    
    public init(routerSeed seed: RouterSeed)
    {
        self.transitionId = seed.transitionId
        self.transitionsHandlerBox = seed.transitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.routerTransitionDelegate = seed.routerTransitionDelegate
        self.transitionsHandlersProvider = seed.transitionsHandlersProvider
        self.transitionIdGenerator = seed.transitionIdGenerator
        self.controllersProvider = seed.controllersProvider
    }

    // MARK: - DetailRouterTransitionable
    open var detailTransitionsHandlerBox: RouterTransitionsHandlerBox {
        return transitionsHandlerBox
    }
}
