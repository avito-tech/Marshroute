import UIKit

/// Роутер, управляющий двумя экранами (двумя UINavigationController'ами)
/// Работает с двумя обработчиками переходов (master и detail).
/// Например, роутер master-контроллера внутри SplitViewController'а
open class BaseMasterDetailRouter:
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
    MasterRouterTransitionable,
    MasterRouter,
    DetailRouterTransitionable,
    DetailRouter,
    RouterControllersProviderHolder,
    RouterAnimatorsProviderHolder
{
    open let masterTransitionsHandlerBox: RouterTransitionsHandlerBox
    open let detailTransitionsHandlerBox: RouterTransitionsHandlerBox
    open let transitionId: TransitionId
    open fileprivate(set) weak var presentingTransitionsHandler: TransitionsHandler?
    open let transitionsHandlersProvider: TransitionsHandlersProvider
    open let transitionIdGenerator: TransitionIdGenerator
    open let controllersProvider: RouterControllersProvider
    open let animatorsProvider: RouterAnimatorsProvider
    
    public init(routerSeed: MasterDetailRouterSeed) {
        self.transitionId = routerSeed.transitionId
        self.masterTransitionsHandlerBox = routerSeed.masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = routerSeed.detailTransitionsHandlerBox
        self.presentingTransitionsHandler = routerSeed.presentingTransitionsHandler
        self.transitionsHandlersProvider = routerSeed.transitionsHandlersProvider
        self.transitionIdGenerator = routerSeed.transitionIdGenerator
        self.controllersProvider = routerSeed.controllersProvider
        self.animatorsProvider = routerSeed.animatorsProvider
    }
    
    // MARK: - RouterTransitionable
    open var transitionsHandlerBox: RouterTransitionsHandlerBox {
        return masterTransitionsHandlerBox
    }
}
