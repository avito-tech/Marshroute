final class NavigationRootsHolder {
    static let instance = NavigationRootsHolder()
    
    var rootTransitionsHandler: TransitionsHandler?
    
    let transitionsCoordinator: TransitionsCoordinator = TransitionsCoordinatorImpl(
        stackClientProvider: TransitionContextsStackClientProviderImpl()
    )
}