import UIKit

public final class TransitionsCoordinatorImpl:
    TransitionContextsStackClientProviderHolder,
    TransitionsCoordinatorDelegateHolder,
    TransitionsCoordinator,
    TopViewControllerFinder,
    TransitionsTracker
{
    // MARK: - TransitionContextsStackClientProviderHolder
    public let stackClientProvider: TransitionContextsStackClientProvider
    
    // MARK: - TransitionsCoordinatorDelegateHolder
    public weak var transitionsCoordinatorDelegate: TransitionsCoordinatorDelegate?
    
    // MARK: - Init
    public init(stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl())
    {
        self.stackClientProvider = stackClientProvider
    }
    
    // MARK: - TopViewControllerFindable
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
        trackedTransition: TrackedTransition,
        untilLastTransitionOfTransitionsHandler targetTransitionsHandler: TransitionsHandler)
        -> Int?
    {
        return countOfTransitionsAfterTrackedTransitionImpl(
            trackedTransition,
            untilLastTransitionOfTransitionsHandler: targetTransitionsHandler
        )
    }
}