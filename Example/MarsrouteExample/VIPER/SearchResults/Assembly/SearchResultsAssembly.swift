import UIKit
import Marshroute

protocol SearchResultsAssembly: class {
    func module(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(categoryId: CategoryId, routerSeed: RouterSeed)
        -> UIViewController
}
