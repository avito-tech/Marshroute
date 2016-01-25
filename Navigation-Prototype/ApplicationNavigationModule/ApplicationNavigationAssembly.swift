import UIKit

protocol ApplicationNavigationAssembly {
    func module(navigationRootsHolder: NavigationRootsHolder) -> (UIViewController, ApplicationNavigationModuleInput)
}
