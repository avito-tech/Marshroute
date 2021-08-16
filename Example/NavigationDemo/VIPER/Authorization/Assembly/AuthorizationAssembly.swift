import UIKit
import Marshroute

protocol AuthorizationAssembly: AnyObject {
    func module(routerSeed: RouterSeed)
        -> (viewController: UIViewController, moduleInput: AuthorizationModuleInput)
}
