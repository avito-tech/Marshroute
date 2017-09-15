import UIKit
import Marshroute

protocol AuthorizationAssembly: class {
    func module(routerSeed: RouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
}
