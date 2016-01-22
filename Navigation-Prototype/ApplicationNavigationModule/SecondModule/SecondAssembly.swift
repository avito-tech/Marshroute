import UIKit

protocol SecondAssembly {
    func iphoneModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String) -> (UIViewController, SecondModuleInput)
    func ipadModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String) -> (UIViewController, SecondModuleInput)
}
