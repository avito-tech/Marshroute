import UIKit
import Marshroute

protocol ShelfAssembly: class {
    func module(routerSeed: RouterSeed)
        -> UIViewController
}
