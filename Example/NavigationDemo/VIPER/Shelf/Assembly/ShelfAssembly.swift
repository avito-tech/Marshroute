import UIKit
import AvitoNavigation

protocol ShelfAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> UIViewController
}
