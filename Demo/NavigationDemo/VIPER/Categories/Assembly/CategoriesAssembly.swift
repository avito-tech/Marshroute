import UIKit
import AvitoNavigation

protocol CategoriesAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(routerSeed routerSeed: MasterDetailRouterSeed)
        -> UIViewController
}

protocol SubcategoriesAssembly: class {
    func module(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadMasterDetailModule(categoryId categoryId: CategoryId, routerSeed: MasterDetailRouterSeed)
        -> UIViewController
}
