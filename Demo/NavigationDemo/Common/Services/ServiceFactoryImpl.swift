import AvitoNavigation

final class ServiceFactoryImpl: ServiceFactory {
    // MARK: - Private properties
    private let searchResultsCacherInstance: SearchResultsCacher
    private let advertisementCacherInstance: AdvertisementCacher
    private let touchEventObserverInstance: TouchEventObserver
    private let touchEventForwarderInstance: TouchEventForwarder
    private let topViewControllerFindingServiceInstance: TopViewControllerFindingService
    
    // MARK: - Init
    init(topViewControllerFinder: TopViewControllerFinder,
         rootTransitionsHandlerProvider: (() -> (ContainingTransitionsHandler?)))
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
}