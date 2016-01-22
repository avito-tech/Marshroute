import Foundation

protocol FirstAssembly {
    func module(title: String, parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, moduleChangeable: Bool) -> (FirstViewController, FirstModuleInput)
    func module(title: String, parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, detailTransitionsHandler: TransitionsHandler?, moduleChangeable: Bool) -> (FirstViewController, FirstModuleInput)
    
}
