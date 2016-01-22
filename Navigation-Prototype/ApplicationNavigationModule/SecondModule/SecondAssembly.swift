import UIKit

protocol SecondAssembly {
    func module(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String) -> (UIViewController, SecondModuleInput)
}
