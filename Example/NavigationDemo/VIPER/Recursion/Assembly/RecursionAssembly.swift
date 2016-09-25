import UIKit
import Marshroute

protocol RecursionAssembly: class {
    func module(routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
}
