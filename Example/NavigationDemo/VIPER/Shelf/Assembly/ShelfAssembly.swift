import UIKit
import Marshroute

protocol ShelfAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> UIViewController
}
