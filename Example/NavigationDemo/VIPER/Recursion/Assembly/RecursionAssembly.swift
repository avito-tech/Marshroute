import UIKit
import Marshroute

protocol RecursionAssembly: AnyObject {
    func module(routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed: RouterSeed)
        -> UIViewController
}
