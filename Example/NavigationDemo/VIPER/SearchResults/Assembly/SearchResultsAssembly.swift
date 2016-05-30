import UIKit
import AvitoNavigation

protocol SearchResultsAssembly: class {
    func module(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
}
