final class TransitionsCoordinatorImpl {
    private let stackClientProviderPrivate: TransitionContextsStackClientProvider
    
    init(stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl())
    {
        self.stackClientProviderPrivate = stackClientProvider
    }
}

// MARK: - TransitionContextsStackClientProviderHolder
extension TransitionsCoordinatorImpl: TransitionContextsStackClientProviderHolder {
    var stackClientProvider: TransitionContextsStackClientProvider {
        return stackClientProviderPrivate
    }
}

// MARK: - TransitionsCoordinator
extension TransitionsCoordinatorImpl: TransitionsCoordinator {}