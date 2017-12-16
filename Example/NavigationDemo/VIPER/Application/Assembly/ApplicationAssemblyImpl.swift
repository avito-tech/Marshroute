import UIKit
import Marshroute

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module(
        routerSeed: RouterSeed,
        instantiateTabViewControllers: (() -> ()),
        isPad: Bool)
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        return existingModule() ?? moduleImpl(
            routerSeed: routerSeed,
            instantiateTabViewControllers: instantiateTabViewControllers,
            isPad: isPad
        )
    }
    
    func sharedApplicationModuleInterface()
        -> ApplicationModule?
    {
        return existingModule()?.interface
    }
    
    // MARK: - Private
    private func existingModule()
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>?
    {
        return ApplicationModuleHolder.instance.applicationModule
    }
    
    private func moduleImpl(
        routerSeed: RouterSeed,
        instantiateTabViewControllers: (() -> ()),
        isPad: Bool)
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {   
        // This demo does not depend on tabs initialization order
        // In your app you can choose another appropriate moment
        instantiateTabViewControllers()
        
        // Banner module
        
        let (bannerView, bannerModuleInput) = assemblyFactory.bannerAssembly().module()
        
        // Application module
        
        let topViewControllerFindingService = serviceFactory.topViewControllerFindingService()
        
        let tabBarController = ApplicationViewController(
            topViewControllerFindingService: topViewControllerFindingService,
            bannerView: bannerView
        )
        
        let interactor = ApplicationInteractorImpl()
        
        let authorizationModuleTrackingService = serviceFactory.authorizationModuleTrackingService()
        
        let router: ApplicationRouter
        
        if isPad {
            router = ApplicationRouterIpad(
                authorizationModuleTrackingService: authorizationModuleTrackingService,
                assemblyFactory: assemblyFactory,
                routerSeed: routerSeed
            )
        } else {
            router = ApplicationRouterIphone(
                authorizationModuleTrackingService: authorizationModuleTrackingService,
                assemblyFactory: assemblyFactory,
                routerSeed: routerSeed
            )
        }
        
        let presenter = ApplicationPresenter(
            interactor: interactor,
            router: router
        )
        
        tabBarController.addDisposable(presenter)
        
        presenter.view = tabBarController
        presenter.bannerModuleInput = bannerModuleInput
        
        let module = AssembledMarshrouteModule(
            viewController: tabBarController as UITabBarController,
            interface: presenter as ApplicationModule,
            disposeBag: tabBarController,
            routerSeed: routerSeed
        )
        
        ApplicationModuleHolder.instance.applicationModule = module
        
        return module
    }
}
