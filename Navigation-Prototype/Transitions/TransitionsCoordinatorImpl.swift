import Foundation

final class TransitionsCoordinatorImpl {
    private let stackClientProviderPrivate: TransitionContextsStackClientProvider
    
    init(stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl())
    {
        self.stackClientProviderPrivate = stackClientProvider
    }
}

// MARK: - TransitionsCoordinator
extension TransitionsCoordinatorImpl: TransitionsCoordinator {}

// MARK: - TransitionContextsStackClientProviderStorer
extension TransitionsCoordinatorImpl: TransitionContextsStackClientProviderStorer {
    var stackClientProvider: TransitionContextsStackClientProvider {
        return stackClientProviderPrivate
    }
}