import UIKit
import Marshroute

protocol SearchResultsAssembly: class {
    func module(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(categoryId categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
}
