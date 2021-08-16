import UIKit
import Marshroute

protocol ShelfAssembly: AnyObject {
    func module(routerSeed: RouterSeed)
        -> UIViewController
}
