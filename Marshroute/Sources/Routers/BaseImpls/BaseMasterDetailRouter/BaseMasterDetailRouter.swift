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
    RouterTransitionDelegateHoder
{
    public let masterTransitionsHandlerBox: RouterTransitionsHandlerBox
    public let detailTransitionsHandlerBox: RouterTransitionsHandlerBox
    public let transitionId: TransitionId
    open fileprivate(set) weak var presentingTransitionsHandler: TransitionsHandler?
    open fileprivate(set) weak var routerTransitionDelegate: RouterTransitionDelegate?
    public let transitionsHandlersProvider: TransitionsHandlersProvider
    public let transitionIdGenerator: TransitionIdGenerator
    public let controllersProvider: RouterControllersProvider
    
    public init(routerSeed seed: MasterDetailRouterSeed)
    {
        self.transitionId = seed.transitionId
        self.masterTransitionsHandlerBox = seed.masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = seed.detailTransitionsHandlerBox
        self.presentingTransitionsHandler = seed.presentingTransitionsHandler
        self.transitionsHandlersProvider = seed.transitionsHandlersProvider
        self.transitionIdGenerator = seed.transitionIdGenerator
        self.controllersProvider = seed.controllersProvider
    }
    
    // MARK: - RouterTransitionable
    open var transitionsHandlerBox: RouterTransitionsHandlerBox {
        return masterTransitionsHandlerBox
    }
}
