import UIKit
import AvitoNavigation

protocol RecursionAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> UIViewController
    
    func ipadModule(routerSeed routerSeed: RouterSeed)
        -> UIViewController
}
