import UIKit
import AvitoNavigation

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> ApplicationModule
    {
        if let savedModule = ApplicationModuleHolder.instance.applicationModule {
            return savedModule
        }
        
        // Banner module
        let (bannerView, bannerModuleInput) = assemblyFactory.bannerAssembly().module()
        
        // Application module
        
        let topViewControllerFindingService = serviceFactory.topViewControllerFindingService()
        
        let tabBarController = ApplicationViewController(
            topViewControllerFindingService: topViewControllerFindingService,
            bannerView: bannerView
        )
        
        let tabBarTransitionsHandler = TabBarTransitionsHandlerImpl(
            tabBarController: tabBarController,
            transitionsCoordinator: moduleSeed.transitionsCoordinator
        )
        
        let tabBarTransitionsHandlerBox = RouterTransitionsHandlerBox(
            containingTransitionsHandler: tabBarTransitionsHandler
        )
        
        let routerSeed = RouterSeed(
            moduleSeed: moduleSeed,
            transitionsHandlerBox: tabBarTransitionsHandlerBox
        )
        
        let interactor = ApplicationInteractorImpl()
        
        let authorizationModuleTrackingService = serviceFactory.authorizationModuleTrackingService()
        
        let router: ApplicationRouter
            
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
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
        
        let tabs = self.tabs(moduleSeed: moduleSeed)
        
        tabBarController.viewControllers = tabs.viewControllers
        tabBarTransitionsHandler.animatingTransitionsHandlers = tabs.animatingTransitionsHandlers
        tabBarTransitionsHandler.containingTransitionsHandlers = tabs.containingTransitionsHandlers
        
        let applicationModule = ApplicationModule(
            viewController: tabBarController,
            moduleInput: presenter,
            transitionsHandler: tabBarTransitionsHandler
        )

        ApplicationModuleHolder.instance.applicationModule = applicationModule
        
        return applicationModule
    }
    
    func sharedModuleInput()
        -> ApplicationModuleInput?
    {
        return ApplicationModuleHolder.instance.applicationModule?.moduleInput
    }
    
    // MARK: - Private
    private func tabs(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> (viewControllers: [UIViewController],
        animatingTransitionsHandlers: [Int: AnimatingTransitionsHandler],
        containingTransitionsHandlers: [Int: ContainingTransitionsHandler])
    {
        if case .Pad = UIDevice.currentDevice().userInterfaceIdiom {
            return ipadTabs(moduleSeed: moduleSeed)
        } else {
            return iphoneTabs(moduleSeed: moduleSeed)
        }
    }
    
    // MARK: - iPad
    private func ipadTabs(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> (viewControllers: [UIViewController],
        animatingTransitionsHandlers: [Int: AnimatingTransitionsHandler],
        containingTransitionsHandlers: [Int: ContainingTransitionsHandler])
    {
        let firstTab = ipadFirstTab(moduleSeed: moduleSeed)
        let secondTab = ipadSecondTab(moduleSeed: moduleSeed)
        
        let viewControllers: [UIViewController] = [
            firstTab.splitViewController,
            secondTab.navigationController
        ]
        
        let animatingTransitionsHandlers = [
            1: secondTab.animatingTransitionsHandler
        ]
        
        let containingTransitionsHandlers = [
            0: firstTab.containingTransitionsHandler,
        ]
        
        return (viewControllers, animatingTransitionsHandlers, containingTransitionsHandlers)
    }
    
    private func ipadFirstTab(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> (splitViewController: UISplitViewController, containingTransitionsHandler: ContainingTransitionsHandler)
    {
        let rootModulesProvider = serviceFactory.rootModulesProvider()
        
        let categoriesAndShelvesModule = rootModulesProvider.masterDetailModule(
            moduleSeed: moduleSeed,
            deriveMasterViewController: { (routerSeed) -> UIViewController in
                let categoriesAssembly = assemblyFactory.categoriesAssembly()
                
                let viewController = categoriesAssembly.ipadMasterDetailModule(routerSeed: routerSeed)
                
                return viewController
            },
            deriveDetailViewController: { (routerSeed) -> UIViewController in
                let shelfAssembly = assemblyFactory.shelfAssembly()
                
                let viewController = shelfAssembly.module(routerSeed: routerSeed)
                
                return viewController
        })
        
        categoriesAndShelvesModule.splitViewController.tabBarItem.title = "advertisements".localized
        
        return categoriesAndShelvesModule
    }
    
    private func ipadSecondTab(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        let rootModulesProvider = serviceFactory.rootModulesProvider()
        
        let recursionModule = rootModulesProvider.detailModule(moduleSeed: moduleSeed) { routerSeed -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.ipadModule(routerSeed: routerSeed)
            
            return viewController
        }
        
        recursionModule.navigationController.tabBarItem.title = "recursion".localized
        
        return recursionModule
    }
    
    // MARK: - iPhone
    private func iphoneTabs(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> (viewControllers: [UIViewController],
        animatingTransitionsHandlers: [Int: AnimatingTransitionsHandler],
        containingTransitionsHandlers: [Int: ContainingTransitionsHandler])
    {
        let firstTab = iphoneFirstTab(moduleSeed: moduleSeed)
        let secondTab = iphoneSecondTab(moduleSeed: moduleSeed)
        
        let viewControllers: [UIViewController] = [
            firstTab.navigationController,
            secondTab.navigationController
        ]
        
        let animatingTransitionsHandlers = [
            0: firstTab.animatingTransitionsHandler,
            1: secondTab.animatingTransitionsHandler
        ]
        
        return (viewControllers, animatingTransitionsHandlers, [:])
    }
    
    private func iphoneFirstTab(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        let rootModulesProvider = serviceFactory.rootModulesProvider()
        
        let categoriesModule = rootModulesProvider.detailModule(moduleSeed: moduleSeed) { routerSeed -> UIViewController in
            let categoriesAssembly = assemblyFactory.categoriesAssembly()
            
            let viewController = categoriesAssembly.module(routerSeed: routerSeed)
            
            return viewController
        }
        
        categoriesModule.navigationController.tabBarItem.title = "advertisements".localized
        
        return categoriesModule
    }
    
    private func iphoneSecondTab(moduleSeed moduleSeed: ApplicationModuleSeed)
    -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        let rootModulesProvider = serviceFactory.rootModulesProvider()
        
        let recursionModule = rootModulesProvider.detailModule(moduleSeed: moduleSeed) { routerSeed -> UIViewController in
            let recursionAssembly = assemblyFactory.recursionAssembly()
            
            let viewController = recursionAssembly.module(routerSeed: routerSeed)
            
            return viewController
        }
        
        recursionModule.navigationController.tabBarItem.title = "recursion".localized
        
        return recursionModule
    }
}