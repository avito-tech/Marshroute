import Foundation

// non-singletons
protocol ServiceFactory: AnyObject {
    func categoriesProvider() -> CategoriesProvider
    func searchResultsProvider() -> SearchResultsProvider
    func advertisementProvider() -> AdvertisementProvider
    func rootModulesProvider() -> RootModulesProvider
    func timerService() -> TimerService
    func searchResultsCacher() -> SearchResultsCacher
    func advertisementCacher() -> AdvertisementCacher
    func touchEventObserver() -> TouchEventObserver
    func touchEventForwarder() -> TouchEventForwarder
    func topViewControllerFindingService() -> TopViewControllerFindingService
    func moduleRegisteringService() -> ModuleRegisteringService
    func moduleTrackingService() -> ModuleTrackingService
    func authorizationModuleRegisteringService() -> AuthorizationModuleRegisteringService
    func authorizationModuleTrackingService() -> AuthorizationModuleTrackingService
}
