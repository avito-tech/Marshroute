import Foundation

final public class MarshrouteNavigationSetupServiceImpl: MarshrouteNavigationSetupService {
    // MARK: - Private properties
    private let factory: MarshrouteNavigationFactory
    
    // MARK: - Init
    public init(factory: MarshrouteNavigationFactory = MarshrouteNavigationFactoryImpl()) {
        self.factory = factory
    }
    
    // MARK: - MarshrouteNavigationSetupService
    public func marshrouteNavigationStack()
        -> MarshrouteNavigationStack
    {
        let transitionIdGenerator = factory.transitionIdGenerator()
        
        let routerControllersProvider = factory.routerControllersProvider()
        
        let stackClientProvider = factory.transitionContextsStackClientProvider()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: stackClientProvider
        )
        
        return MarshrouteNavigationStack(
            transitionIdGenerator: transitionIdGenerator,
            routerControllersProvider: routerControllersProvider,
            transitionsCoordinator: transitionsCoordinator,
            transitionsCoordinatorDelegateHolder: transitionsCoordinator,
            topViewControllerFinder: transitionsCoordinator,
            transitionsMarker: transitionsCoordinator,
            transitionsTracker: transitionsCoordinator,
            transitionsHandlersProvider: transitionsCoordinator
        )
    }
}