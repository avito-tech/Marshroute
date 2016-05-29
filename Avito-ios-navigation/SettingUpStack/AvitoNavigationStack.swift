import Foundation

public struct AvitoNavigationStack {
    let transitionIdGenerator: TransitionIdGenerator
    let controllersProvider: RouterControllersProvider
    let transitionsCoordinator: TransitionsCoordinator
    let transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder
    let topViewControllerFinder: TopViewControllerFinder
    let transitionsMarker: TransitionsMarker
    let transitionsTracker: TransitionsTracker
    let transitionsHandlersProvider: TransitionsHandlersProvider
    
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