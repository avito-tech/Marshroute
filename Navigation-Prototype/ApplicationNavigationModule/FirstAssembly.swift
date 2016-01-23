import Foundation

protocol FirstAssembly {
    func iphoneModule(title: String, parentRouter: RouterDismisable?,
        transitionsHandler: TransitionsHandler?,
        canShowFirstModule: Bool, canShowSecondModule: Bool,
        dismissable: Bool)
        -> (FirstViewController, FirstModuleInput)
    
    func ipadDetailModule(title: String, parentRouter: RouterDismisable?,
        transitionsHandler: TransitionsHandler?,
        canShowFirstModule: Bool, canShowSecondModule: Bool,
        dismissable: Bool)
        -> (FirstViewController, FirstModuleInput)
    
    func ipadMasterModule(title: String, parentRouter: RouterDismisable?,
        transitionsHandler: TransitionsHandler?, detailTransitionsHandler: TransitionsHandler?,
        canShowFirstModule: Bool, canShowSecondModule: Bool,
        dismissable: Bool)
        -> (FirstViewController, FirstModuleInput)
    
}
