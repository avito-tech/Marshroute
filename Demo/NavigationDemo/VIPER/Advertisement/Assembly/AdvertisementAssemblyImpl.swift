import UIKit
import AvitoNavigation

final class AdvertisementAssemblyImpl: BaseAssembly, AdvertisementAssembly {
    // MARK: - AdvertisementAssembly
    func module(searchResultId searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = AdvertisementRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(searchResultId: searchResultId, router: router)
    }
    
    func ipadModule(searchResultId searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = AdvertisementRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(searchResultId: searchResultId, router: router)
    }
    
    // MARK - Private
    func module(searchResultId searchResultId: SearchResultId, router: AdvertisementRouter)
        -> UIViewController
    {
        let interactor = AdvertisementInteractorImpl(
            advertisementId: (searchResultId as AdvertisementId),
            advertisementProvider: serviceFactory.advertisementProvider()
        )
        
        let presenter = AdvertisementPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = AdvertisementViewController()
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
