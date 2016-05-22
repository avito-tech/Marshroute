import AvitoNavigation

final class ApplicationModuleSeedProvider {
    func applicationModuleSeed() -> ApplicationModuleSeed {
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let transitionId = transitionIdGenerator.generateNewTransitionId()
        
        let transitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: transitionContextsStackClientProvider
        )
        
        let controllersProvider = RouterControllersProviderImpl()
        
        let result = ApplicationModuleSeed(
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionsCoordinatorDelegateHolder: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            topViewControllerFinder: transitionsCoordinator,
            transitionsMarker: transitionsCoordinator,
            transitionsTracker: transitionsCoordinator
        )
        
        return result
    }
}