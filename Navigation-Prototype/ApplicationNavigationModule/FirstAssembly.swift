import Foundation

protocol FirstAssembly {
    func module(title: String, parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, forIphone: Bool, moduleChangeable: Bool) -> (FirstViewController, FirstModuleInput)
}
