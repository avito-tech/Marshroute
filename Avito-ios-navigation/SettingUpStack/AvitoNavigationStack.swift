import Foundation

public struct AvitoNavigationStack {
    public let transitionIdGenerator: TransitionIdGenerator
    public let controllersProvider: RouterControllersProvider
    public let transitionsCoordinator: TransitionsCoordinator
    public let transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder
    public let topViewControllerFinder: TopViewControllerFinder
    public let transitionsMarker: TransitionsMarker
    public let transitionsTracker: TransitionsTracker
    public let transitionsHandlersProvider: TransitionsHandlersProvider
    
    public init(
        transitionIdGenerator: TransitionIdGenerator,
        controllersProvider: RouterControllersProvider,
        transitionsCoordinator: TransitionsCoordinator,
        transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder,
        topViewControllerFinder: TopViewControllerFinder,
        transitionsMarker: TransitionsMarker,
        transitionsTracker: TransitionsTracker,
        transitionsHandlersProvider: TransitionsHandlersProvider)
    {
        self.transitionIdGenerator = transitionIdGenerator
        self.controllersProvider = controllersProvider
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionsCoordinatorDelegateHolder = transitionsCoordinatorDelegateHolder
        self.topViewControllerFinder = topViewControllerFinder
        self.transitionsMarker = transitionsMarker
        self.transitionsTracker = transitionsTracker
        self.transitionsHandlersProvider = transitionsHandlersProvider
    }
}