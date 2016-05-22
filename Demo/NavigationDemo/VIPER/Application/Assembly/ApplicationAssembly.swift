import UIKit
import AvitoNavigation

struct ApplicationModule {
    var viewController: UIViewController
    var moduleInput: ApplicationModuleInput
    var transitionsHandler: ContainingTransitionsHandler
}

protocol ApplicationAssembly: class {
    func module(moduleSeed moduleSeed: ApplicationModuleSeed)
        -> ApplicationModule
    
    func sharedModuleInput()
        -> ApplicationModuleInput?
}
