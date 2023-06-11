import UIKit
import Marshroute

enum ShelfStyle: Int {
    case root
    case modalWithNavigationBar
    case modalBottomSheetWithNavigationBar
    case modalBottomSheetWithoutNavigationBar
}

protocol ShelfAssembly: AnyObject {
    func module(
        style: ShelfStyle,
        routerSeed: RouterSeed)
        -> (ShelfModule, UIViewController)
}
