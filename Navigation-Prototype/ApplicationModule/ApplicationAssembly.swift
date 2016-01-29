import UIKit

protocol ApplicationAssembly {
    func module(navigationRootsHolder: NavigationRootsHolder) -> (UIViewController, ApplicationModuleInput)
}
