import UIKit
import Marshroute

protocol CategoriesAssembly: class {
    func module(routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(routerSeed: MasterDetailRouterSeed)
        -> UIViewController
}

protocol SubcategoriesAssembly: class {
    func module(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(categoryId: CategoryId, routerSeed: MasterDetailRouterSeed)
        -> UIViewController
}
