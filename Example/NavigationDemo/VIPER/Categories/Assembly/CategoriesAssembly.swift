import UIKit
import Marshroute

protocol CategoriesAssembly: AnyObject {
    func module(routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(routerSeed: MasterDetailRouterSeed)
        -> UIViewController
}

protocol SubcategoriesAssembly: AnyObject {
    func module(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(categoryId: CategoryId, routerSeed: MasterDetailRouterSeed)
        -> UIViewController
}
