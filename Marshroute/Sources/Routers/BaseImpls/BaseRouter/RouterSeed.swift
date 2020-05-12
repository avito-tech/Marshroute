import Foundation

/// Параметры для создания роутеров, управляющих одним экраном (одним UINavigationController'ом)
public struct RouterSeed {
    public let transitionsHandlerBox: RouterTransitionsHandlerBox
    public let transitionId: TransitionId
    public let presentingTransitionsHandler: TransitionsHandler?
    public let transitionsHandlersProvider: TransitionsHandlersProvider
    public let transitionIdGenerator: TransitionIdGenerator
    public let controllersProvider: RouterControllersProvider
    public private(set) weak var routerTransitionDelegate: RouterTransitionDelegate?
   
    public init(
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsHandlersProvider: TransitionsHandlersProvider,
        transitionIdGenerator: TransitionIdGenerator,
        controllersProvider: RouterControllersProvider,
        routerTransitionDelegate: RouterTransitionDelegate?)
    {        
        self.transitionsHandlerBox = transitionsHandlerBox
        self.transitionId = transitionId
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsHandlersProvider = transitionsHandlersProvider
        self.transitionIdGenerator = transitionIdGenerator
        self.controllersProvider = controllersProvider
        self.routerTransitionDelegate = routerTransitionDelegate
    }
}
