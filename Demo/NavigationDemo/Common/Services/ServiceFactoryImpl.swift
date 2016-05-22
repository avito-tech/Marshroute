import AvitoNavigation

final class ServiceFactoryImpl: ServiceFactory {
    // MARK: - Private properties
    private let searchResultsCacherInstance: SearchResultsCacher
    private let advertisementCacherInstance: AdvertisementCacher
    private let touchEventObserverInstance: TouchEventObserver
    private let touchEventForwarderInstance: TouchEventForwarder
    private let topViewControllerFindingServiceInstance: TopViewControllerFindingService
    private let moduleTrackingServiceInstance: ModuleTrackingService
    
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
        
        let moduleTrackingServiceInstance = ModuleTrackingServiceImpl(
            transitionsTracker: transitionsTracker,
            transitionsMarker: transitionsMarker,
            distanceThresholdBetweenSiblingModules: 0 //1
        )
        
        self.moduleTrackingServiceInstance = moduleTrackingServiceInstance
        
        transitionsCoordinatorDelegateHolder.transitionsCoordinatorDelegate = moduleTrackingServiceInstance
    }
    
    // MARK: - ServiceFactory
    func categoriesProvider() -> CategoriesProvider {
        return CategoriesProviderImpl()
    }
    
    func searchResultsProvider() -> SearchResultsProvider {
        return SearchResultsProviderImpl(
            searchResultsCacher: searchResultsCacher(),
            randomStringGenerator: randomStringGenerator(),
            categoriesProvider: categoriesProvider()
        )
    }
    
    func advertisementProvider() -> AdvertisementProvider {
        return AdvertisementProviderImpl(
            searchResultsProvider: searchResultsProvider(),
            advertisementCacher: advertisementCacher(),
            randomStringGenerator: randomStringGenerator()
        )
    }
    
    func randomStringGenerator() -> RandomStringGenerator {
        return RandomStringGeneratorImpl()
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
    
    func moduleTrackingService() -> ModuleTrackingService {
        return moduleTrackingServiceInstance
    }
}