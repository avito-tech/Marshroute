import Foundation

public struct MarshrouteStack {
    public let transitionIdGenerator: TransitionIdGenerator
    public let routerControllersProvider: RouterControllersProvider
    public let transitionsCoordinator: TransitionsCoordinator
    public let transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder
    public let topViewControllerFinder: TopViewControllerFinder
    public let transitionsMarker: TransitionsMarker
    public let transitionsTracker: TransitionsTracker
    public let transitionsHandlersProvider: TransitionsHandlersProvider
    public let peekAndPopUtility: PeekAndPopUtility
    public let peekAndPopStateObservable: PeekAndPopStateObservable
    public let peekAndPopStateViewControllerObservable: PeekAndPopStateViewControllerObservable
    
    public init(
        transitionIdGenerator: TransitionIdGenerator,
        routerControllersProvider: RouterControllersProvider,
        transitionsCoordinator: TransitionsCoordinator,
        transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder,
        topViewControllerFinder: TopViewControllerFinder,
        transitionsMarker: TransitionsMarker,
        transitionsTracker: TransitionsTracker,
        transitionsHandlersProvider: TransitionsHandlersProvider,
        peekAndPopUtility: PeekAndPopUtility,
        peekAndPopStateObservable: PeekAndPopStateObservable,
        peekAndPopStateViewControllerObservable: PeekAndPopStateViewControllerObservable)
    {
        self.transitionIdGenerator = transitionIdGenerator
        self.routerControllersProvider = routerControllersProvider
        self.transitionsCoordinator = transitionsCoordinator
        self.transitionsCoordinatorDelegateHolder = transitionsCoordinatorDelegateHolder
        self.topViewControllerFinder = topViewControllerFinder
        self.transitionsMarker = transitionsMarker
        self.transitionsTracker = transitionsTracker
        self.transitionsHandlersProvider = transitionsHandlersProvider
        self.peekAndPopUtility = peekAndPopUtility
        self.peekAndPopStateObservable = peekAndPopStateObservable
        self.peekAndPopStateViewControllerObservable = peekAndPopStateViewControllerObservable
    }
}
