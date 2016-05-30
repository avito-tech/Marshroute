import UIKit
import Marshroute

protocol AuthorizationAssembly: class {
    func module(routerSeed routerSeed: RouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
}
