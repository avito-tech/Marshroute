import UIKit
import Marshroute

final class AdvertisementAssemblyImpl: BaseAssembly, AdvertisementAssembly {
    // MARK: - AdvertisementAssembly
    func module(searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = AdvertisementRouterIphone(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(
            searchResultId: searchResultId,
            router: router,
            transitionsHandlerBox: routerSeed.transitionsHandlerBox,
            transitionId: routerSeed.transitionId
        )
    }
    
    func ipadModule(searchResultId: SearchResultId, routerSeed: RouterSeed)
        -> UIViewController
    {
        let router = AdvertisementRouterIpad(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        return module(
            searchResultId: searchResultId,
            router: router,
            transitionsHandlerBox: routerSeed.transitionsHandlerBox,
            transitionId: routerSeed.transitionId
        )
    }
    
    // MARK - Private
    func module(
        searchResultId: SearchResultId,
        router: AdvertisementRouter,
        transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
        -> UIViewController
    {
        registerModuleAsBeingTracked(
            searchResultId: searchResultId,
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId
        )
        
        let interactor = AdvertisementInteractorImpl(
            advertisementId: (searchResultId as AdvertisementId),
            advertisementProvider: serviceFactory.advertisementProvider()
        )
        
        let presenter = AdvertisementPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = AdvertisementViewController(
            peekAndPopStateViewControllerObservable: marshrouteStack.peekAndPopStateViewControllerObservable,
            peekAndPopUtility: marshrouteStack.peekAndPopUtility
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
    
    // MARK: - Private
    fileprivate func registerModuleAsBeingTracked(
        searchResultId: SearchResultId,
        transitionsHandlerBox: TransitionsHandlerBox,
        transitionId: TransitionId)
    {
        let trackedModule = TrackedModule(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            transitionUserId: String(describing: AdvertisementAssemblyImpl.self) + " " + searchResultId
        )
     
        // debugPrint(trackedModule.transitionUserId)
        
        let moduleRegisteringService = serviceFactory.moduleRegisteringService()
        
        moduleRegisteringService.registerTrackedModule(trackedModule)
    }
}
