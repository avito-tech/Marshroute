import Foundation

/// Параметры для создания роутеров, управляющих двумя экранами (двумя UINavigationController'ами)
public struct MasterDetailRouterSeed {
    public let masterTransitionsHandlerBox: RouterTransitionsHandlerBox
    public let detailTransitionsHandlerBox: RouterTransitionsHandlerBox
    public let transitionId: TransitionId
    public let presentingTransitionsHandler: TransitionsHandler?
    public let transitionsHandlersProvider: TransitionsHandlersProvider
    public let transitionIdGenerator: TransitionIdGenerator
    public let controllersProvider: RouterControllersProvider
    public private(set) weak var routerTransitionDelegate: RouterTransitionDelegate?
    
    public init(
        masterTransitionsHandlerBox: RouterTransitionsHandlerBox,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsHandlersProvider: TransitionsHandlersProvider,
        transitionIdGenerator: TransitionIdGenerator,
        controllersProvider: RouterControllersProvider,
        routerTransitionDelegate: RouterTransitionDelegate?)
    {        
        self.masterTransitionsHandlerBox = masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = detailTransitionsHandlerBox
        self.transitionId = transitionId
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsHandlersProvider = transitionsHandlersProvider
        self.transitionIdGenerator = transitionIdGenerator
        self.controllersProvider = controllersProvider
        self.routerTransitionDelegate = routerTransitionDelegate
    }
}
