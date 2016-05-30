import Marshroute

final class ServiceFactoryImpl: ServiceFactory {
    // MARK: - Private properties
    private let searchResultsCacherInstance: SearchResultsCacher
    private let advertisementCacherInstance: AdvertisementCacher
    private let touchEventObserverInstance: TouchEventObserver
    private let touchEventForwarderInstance: TouchEventForwarder
    private let topViewControllerFindingServiceInstance: TopViewControllerFindingService
    private let moduleRegisteringServiceInstance: ModuleRegisteringServiceImpl
    
    // MARK: - Init
    init(topViewControllerFinder: TopViewControllerFinder,
         rootTransitionsHandlerProvider: (() -> (ContainingTransitionsHandler?)),
         transitionsMarker: TransitionsMarker,
         transitionsTracker: TransitionsTracker,
         transitionsCoordinatorDelegateHolder: TransitionsCoordinatorDelegateHolder)
    {
        searchResultsCacherInstance = SearchResultsCacherImpl()
        
        advertisementCacherInstance = AdvertisementCacherImpl()
        
        let touchEventObserverAndForwarder = TouchEventObserverImpl()
        touchEventObserverInstance = touchEventObserverAndForwarder
        touchEventForwarderInstance = touchEventObserverAndForwarder
        
        topViewControllerFindingServiceInstance = TopViewControllerFindingServiceImpl(
            topViewControllerFinder: topViewControllerFinder,
            rootTransitionsHandlerProvider: rootTransitionsHandlerProvider
        )
        
        let moduleRegisteringServiceInstance = ModuleRegisteringServiceImpl(
            transitionsTracker: transitionsTracker,
            transitionsMarker: transitionsMarker,
            distanceThresholdBetweenSiblingModules: 1,
            rootTransitionsHandlerProvider: rootTransitionsHandlerProvider
        )
        
        self.moduleRegisteringServiceInstance = moduleRegisteringServiceInstance
        
        transitionsCoordinatorDelegateHolder.transitionsCoordinatorDelegate = moduleRegisteringServiceInstance
    }
    
    // MARK: - ServiceFactory
    func categoriesProvider() -> CategoriesProvider {
        return CategoriesProviderImpl()
    }
    
    func searchResultsProvider() -> SearchResultsProvider {
        return SearchResultsProviderImpl(
            searchResultsCacher: searchResultsCacher(),
            categoriesProvider: categoriesProvider()
        )
    }
    
    func advertisementProvider() -> AdvertisementProvider {
        return AdvertisementProviderImpl(
            searchResultsProvider: searchResultsProvider(),
            advertisementCacher: advertisementCacher()
        )
    }
    
    func rootModulesProvider() -> RootModulesProvider {
        return RootModulesProviderImpl()
    }
    
    func timerService() -> TimerService {
        return TimerServiceImpl()
    }

    func searchResultsCacher() -> SearchResultsCacher {
        return searchResultsCacherInstance
    }
    
    func advertisementCacher() -> AdvertisementCacher {
        return advertisementCacherInstance
    }
    
    func touchEventObserver() -> TouchEventObserver {
        return touchEventObserverInstance
    }
    
    func touchEventForwarder() -> TouchEventForwarder {
        return touchEventForwarderInstance
    }
    
    func topViewControllerFindingService() -> TopViewControllerFindingService {
        return topViewControllerFindingServiceInstance
    }
    
    func moduleRegisteringService() -> ModuleRegisteringService {
        return moduleRegisteringServiceInstance
    }
    
    func moduleTrackingService() -> ModuleTrackingService {
        return moduleRegisteringServiceInstance
    }
    
    func authorizationModuleRegisteringService() -> AuthorizationModuleRegisteringService {
        return moduleRegisteringServiceInstance
    }
    
    func authorizationModuleTrackingService() -> AuthorizationModuleTrackingService {
        return moduleRegisteringServiceInstance
    }
}