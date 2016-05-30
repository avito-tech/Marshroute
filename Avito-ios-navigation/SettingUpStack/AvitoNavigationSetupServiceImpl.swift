import Foundation

final public class AvitoNavigationSetupServiceImpl: AvitoNavigationSetupService {
    // MARK: - Private properties
    private let factory: AvitoNavigationFactory
    
    // MARK: - Init
    public init(factory: AvitoNavigationFactory = AvitoNavigationFactoryImpl()) {
        self.factory = factory
    }
    
    // MARK: - AvitoNavigationSetupService
    public func avitoNavigationStack()
        -> AvitoNavigationStack
    {
        let transitionIdGenerator = factory.transitionIdGenerator()
        
        let routerControllersProvider = factory.routerControllersProvider()
        
        let stackClientProvider = factory.transitionContextsStackClientProvider()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: stackClientProvider
        )
        
        return AvitoNavigationStack(
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