import UIKit

public final class TransitionsCoordinatorImpl:
    TransitionContextsStackClientProviderHolder,
    TransitionsCoordinatorDelegateHolder,
    TransitionsCoordinator,
    TopViewControllerFinder
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
        return findTopViewControllerImpl(animatingTransitionsHandler: transitionsHandler)
    }

    public func findTopViewController(containingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> UIViewController?
    {
        return findTopViewControllerImpl(containingTransitionsHandler: transitionsHandler)
    }
}