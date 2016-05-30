import UIKit
import AvitoNavigation

protocol AuthorizationAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
}
