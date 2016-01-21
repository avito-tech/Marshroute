import Foundation

protocol FirstAssembly {
    func module(title: String, parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?) -> (FirstViewController, FirstModuleInput)
}
