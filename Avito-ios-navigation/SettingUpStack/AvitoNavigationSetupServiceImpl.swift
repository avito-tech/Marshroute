import Foundation

final public class AvitoNavigationSetupServiceImpl: AvitoNavigationSetupService {
    // MARK: - Init
    public init() {}
    
    // MARK: - AvitoNavigationSetupService
    public func avitoNavigationStack()
        -> AvitoNavigationStack
    {
        let transitionContextsStackClientProvider = TransitionContextsStackClientProviderImpl()
        
        return avitoNavigationStackImpl(transitionContextsStackClientProvider)
    }
    
    public func avitoNavigationStack(transitionContextsStackClientProvider: TransitionContextsStackClientProvider)
        -> AvitoNavigationStack
    {
        return avitoNavigationStackImpl(transitionContextsStackClientProvider)
    }
    
    // MARK: - Private
    private func avitoNavigationStackImpl(transitionContextsStackClientProvider: TransitionContextsStackClientProvider)
         -> AvitoNavigationStack
    {
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let controllersProvider = RouterControllersProviderImpl()
    
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: transitionContextsStackClientProvider
        )
     
        return AvitoNavigationStack(
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            transitionsCoordinator: transitionsCoordinator,
            transitionsCoordinatorDelegateHolder: transitionsCoordinator,
            topViewControllerFinder: transitionsCoordinator,
            transitionsMarker: transitionsCoordinator,
            transitionsTracker: transitionsCoordinator,
            transitionsHandlersProvider: transitionsCoordinator
        )
    }
}