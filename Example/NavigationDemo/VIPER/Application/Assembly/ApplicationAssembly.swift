import UIKit
import Marshroute

protocol ApplicationAssembly: class {
    func module()
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    
    func ipadModule()
        -> AssembledMarshrouteModule<UITabBarController, ApplicationModule>
    
    func sharedModuleInput()
        -> ApplicationModule?
}
