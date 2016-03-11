import UIKit

public final class TransitionsCoordinatorImpl {
    public let stackClientProvider: TransitionContextsStackClientProvider
    
    public init(stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl())
    {
        self.stackClientProvider = stackClientProvider
    }
}

// MARK: - TransitionContextsStackClientProviderHolder
extension TransitionsCoordinatorImpl: TransitionContextsStackClientProviderHolder {}

// MARK: - TransitionsCoordinator
extension TransitionsCoordinatorImpl: TransitionsCoordinator {}

// MARK: - TopViewControllerFindable
extension TransitionsCoordinatorImpl: TopViewControllerFindable {
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