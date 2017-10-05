import UIKit
import Marshroute

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module()
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        return existingModule() ?? module(isPad: false)
    }
    
    func ipadModule()
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        return existingModule() ?? module(isPad: true)
    }
    
    func sharedModuleInput()
        -> ApplicationModule?
    {
        return existingModule()?.interface
    }
    
    // MARK: - Private
    private func existingModule()
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>?
    {
        return ApplicationModuleHolder.init().applicationModule
    }
    
    private func module(isPad: Bool)
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        var result: AssembledMarshrouteModule<UITabBarController, ApplicationModule>!
     
        _ = MarshrouteFacade().tabBarModule(
            deriveTabBarController: { routerSeed in 
                result = self.module(routerSeed: routerSeed, isPad: isPad)
                return result.viewController
            },
            deriveTabViewControllersFromFunctions: tabDeriviationFunctions(isPad: isPad)
        )
        
        return result
    }
    
    private func module(
        routerSeed: RouterSeed,
        isPad: Bool)
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {   
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
    
    private func tabDeriviationFunctions(isPad: Bool)
        -> [TabControllerDeriviationFunctionType]
    {
        return isPad ? ipadTabDeriviationFunctions() : iponeTabDeriviationFunctions()
    }
    
    private func iponeTabDeriviationFunctions()
        -> [TabControllerDeriviationFunctionType]
    {
        let result: [TabControllerDeriviationFunctionType] = [
            .deriveDetailViewControllerInNavigationController { routerSeed in
                self.assemblyFactory.categoriesAssembly().module(routerSeed: routerSeed)
            },
            .deriveDetailViewControllerInNavigationController { routerSeed in
                self.assemblyFactory.recursionAssembly().module(routerSeed: routerSeed)
            }
        ]
        return result
    }
    
    private func ipadTabDeriviationFunctions()
        -> [TabControllerDeriviationFunctionType]
    {
        let result: [TabControllerDeriviationFunctionType] = [
            .deriveMasterDetailViewController(
                masterViewControllerInNavigationController: { routerSeed in
                    self.assemblyFactory.categoriesAssembly().ipadMasterDetailModule(routerSeed: routerSeed)
                },
                detailViewControllerInNavigationController: { routerSeed in
                    self.assemblyFactory.shelfAssembly().module(routerSeed: routerSeed)
                }
            ),
            .deriveDetailViewControllerInNavigationController { routerSeed in
                self.assemblyFactory.recursionAssembly().module(routerSeed: routerSeed)
            }
        ]
        return result
    }
}
