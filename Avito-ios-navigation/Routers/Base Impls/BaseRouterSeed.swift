import Foundation

/// Параметры для создания роутеров, управляющих одним экраном (одним UINavigationController'ом)
public struct BaseRouterSeed {
    public let transitionsHandlerBox: RouterTransitionsHandlerBox
    public let transitionId: TransitionId
    public let presentingTransitionsHandler: TransitionsHandler?
    public let transitionsCoordinator: TransitionsCoordinator
    public let transitionIdGenerator: TransitionIdGenerator
    
    public init(
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
    {
        self.transitionsHandlerBox = transitionsHandlerBox
        self.transitionId = transitionId
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionIdGenerator = transitionIdGenerator
    }
    
}