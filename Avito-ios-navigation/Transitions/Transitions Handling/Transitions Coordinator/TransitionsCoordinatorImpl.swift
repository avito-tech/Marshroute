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