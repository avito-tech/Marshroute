import Foundation

/// Параметры для создания BaseMasterDetailRouter'ов, 
/// управляющих двумя экранами (двумя UINavigationController'ами)
public struct MasterDetailRouterSeed {
    public let masterTransitionsHandlerBox: RouterTransitionsHandlerBox
    public let detailTransitionsHandlerBox: RouterTransitionsHandlerBox
    public let transitionId: TransitionId
    public let presentingTransitionsHandler: TransitionsHandler?
    public let transitionsCoordinator: TransitionsCoordinator
    public let transitionIdGenerator: TransitionIdGenerator
    
    public init(
        masterTransitionsHandlerBox: RouterTransitionsHandlerBox,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
    {
        self.masterTransitionsHandlerBox = masterTransitionsHandlerBox
        self.detailTransitionsHandlerBox = detailTransitionsHandlerBox
        self.transitionId = transitionId
        self.presentingTransitionsHandler = presentingTransitionsHandler
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionIdGenerator = transitionIdGenerator
    }
}