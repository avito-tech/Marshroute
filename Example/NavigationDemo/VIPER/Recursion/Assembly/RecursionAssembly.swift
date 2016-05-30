import UIKit
import Marshroute

protocol RecursionAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed routerSeed: RouterSeed)
        -> UIViewController
}
