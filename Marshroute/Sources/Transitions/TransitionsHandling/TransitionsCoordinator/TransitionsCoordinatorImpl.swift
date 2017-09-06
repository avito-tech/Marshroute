import UIKit

public final class TransitionsCoordinatorImpl:
    TransitionContextsStackClientProviderHolder,
    TransitionsCoordinatorDelegateHolder,
    TransitionsCoordinator,
    TopViewControllerFinder,
    TransitionsTracker,
    TransitionsMarker,
    TransitionsMarkersHolder,
    TransitionsHandlersProvider,
    PeekAndPopTransitionsCoordinatorHolder
{
    // MARK: - TransitionContextsStackClientProviderHolder
    public let stackClientProvider: TransitionContextsStackClientProvider
    
    // MARK: - TransitionsCoordinatorDelegateHolder
    public weak var transitionsCoordinatorDelegate: TransitionsCoordinatorDelegate?
    
    // MARK: - TransitionsMarkersHolder
    public var markers = [TransitionId: TransitionUserId]()
    
    // MARK: - PeekAndPopTransitionsCoordinatorHolder
    public let peekAndPopTransitionsCoordinator: PeekAndPopTransitionsCoordinator
    
    // MARK: - Init
    public init(
        stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl(),
        peekAndPopTransitionsCoordinator: PeekAndPopTransitionsCoordinator)
    {
        self.stackClientProvider = stackClientProvider
        self.peekAndPopTransitionsCoordinator = peekAndPopTransitionsCoordinator
    }
    
    // MARK: - TopViewControllerFinder
    public func findTopViewController(animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
        -> UIViewController?
    {
        return findTopViewControllerImpl(
            forTransitionsHandlerBox: .init(
                animatingTransitionsHandler: transitionsHandler
            )
        )
    }

    public func findTopViewController(containingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> UIViewController?
    {
        return findTopViewControllerImpl(
            forTransitionsHandlerBox: .init(
                containingTransitionsHandler: transitionsHandler
            )
        )
    }
    
    // MARK: - TransitionsTracker
    public func countOfTransitionsAfterTrackedTransition(
        _ trackedTransition: TrackedTransition,
        untilLastTransitionOfTransitionsHandler targetTransitionsHandler: TransitionsHandler)
        -> Int?
    {
        return countOfTransitionsAfterTrackedTransitionImpl(
            trackedTransition,
            untilLastTransitionOfTransitionsHandler: targetTransitionsHandler
        )
    }
    
    public func restoredTransitionFromTrackedTransition(
        _ trackedTransition: TrackedTransition,
        searchingFromTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
        -> RestoredTransitionContext?
    {
        return restoredTransitionFromTrackedTransition(
            trackedTransition,
            searchingFromTransitionsHandlerBox: .init(animatingTransitionsHandler: transitionsHandler)
        )
    }
    
    public func restoredTransitionFromTrackedTransition(
        _ trackedTransition: TrackedTransition,
        searchingFromTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> RestoredTransitionContext?
    {
        return restoredTransitionFromTrackedTransition(
            trackedTransition,
            searchingFromTransitionsHandlerBox: .init(containingTransitionsHandler: transitionsHandler)
        )
    }
    
    // MARK: - TransitionsMarker
    public func markTransitionId(_ transitionId: TransitionId, withUserId userId: TransitionUserId) {
        markTransitionIdImpl(transitionId: transitionId, withUserId: userId)
    }
    
    // MARK: - TransitionsHandlersProvider
    public func animatingTransitionsHandler()
        -> AnimatingTransitionsHandler
    {
        return animatingTransitionsHandlerImpl()
    }
    
    public func navigationTransitionsHandler(navigationController: UINavigationController)
        -> NavigationTransitionsHandlerImpl
    {
        return navigationTransitionsHandlerImpl(navigationController: navigationController)
    }
    
    public func topTransitionsHandlerBox(transitionsHandlerBox: TransitionsHandlerBox)
        -> TransitionsHandlerBox
    {
        return topTransitionsHandlerBoxImpl(transitionsHandlerBox: transitionsHandlerBox)
    }
    
    public func splitViewTransitionsHandler(splitViewController: UISplitViewController)
        -> SplitViewTransitionsHandlerImpl
    {
        return splitViewTransitionsHandlerImpl(splitViewController: splitViewController)
    }
    
    public func tabBarTransitionsHandler(tabBarController: UITabBarController)
        -> TabBarTransitionsHandlerImpl
    {
        return tabBarTransitionsHandlerImpl(tabBarController: tabBarController)
    }
}
