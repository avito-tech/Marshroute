import UIKit
import AvitoNavigation

protocol AuthorizationAssembly: class {
    func module(routerSeed routerSeed: RouterSeed, moduleOutput: AuthorizationModuleOutput)
        -> UIViewController
}
