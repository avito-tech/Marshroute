import UIKit
import Marshroute

struct ApplicationModule {
    var viewController: UIViewController
    var moduleInput: ApplicationModuleInput
    var transitionsHandler: ContainingTransitionsHandler
}

protocol ApplicationAssembly: AnyObject {
    func module(moduleSeed: ApplicationModuleSeed)
        -> ApplicationModule
    
    func ipadModule(moduleSeed: ApplicationModuleSeed)
        -> ApplicationModule
    
    func sharedModuleInput()
        -> ApplicationModuleInput?
}
