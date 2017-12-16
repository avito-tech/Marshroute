import UIKit
import Marshroute

protocol ApplicationAssembly: class {
    func module(
        routerSeed: RouterSeed,
        instantiateTabViewControllers: (() -> ()),
        isPad: Bool)
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    
    func sharedApplicationModuleInterface()
        -> ApplicationModule?
}

extension ApplicationAssembly {
    func iphoneModule(
        routerSeed: RouterSeed,
        instantiateTabViewControllers: (() -> ()))
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        return module(
            routerSeed: routerSeed,
            instantiateTabViewControllers: instantiateTabViewControllers,
            isPad: false
        )
    }
    
    func ipadModule(
        routerSeed: RouterSeed,
        instantiateTabViewControllers: (() -> ()))
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    {
        return module(
            routerSeed: routerSeed,
            instantiateTabViewControllers: instantiateTabViewControllers,
            isPad: true
        )
    }
}
