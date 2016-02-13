final class TransitionsCoordinatorImpl {
    let stackClientProvider: TransitionContextsStackClientProvider
    
    init(stackClientProvider: TransitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl())
    {
        self.stackClientProvider = stackClientProvider
    }
}

// MARK: - TransitionContextsStackClientProviderHolder
extension TransitionsCoordinatorImpl: TransitionContextsStackClientProviderHolder {}

// MARK: - TransitionsCoordinator
extension TransitionsCoordinatorImpl: TransitionsCoordinator {}