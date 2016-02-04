import Foundation

final class TransitionsCoordinatorImpl {
    private let stackClientProviderPrivate: TransitionContextsStackClientProvider
    
    init(stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl())
    {
        self.stackClientProviderPrivate = stackClientProvider
    }
}

// MARK: - TransitionContextsStackClientProviderStorer
extension TransitionsCoordinatorImpl: TransitionContextsStackClientProviderStorer {
    var stackClientProvider: TransitionContextsStackClientProvider {
        return stackClientProviderPrivate
    }
}

// MARK: - TransitionsCoordinator
extension TransitionsCoordinatorImpl: TransitionsCoordinator {}