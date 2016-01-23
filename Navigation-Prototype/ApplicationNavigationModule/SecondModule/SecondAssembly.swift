import UIKit

protocol SecondAssembly {
    func iphoneModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String, withTimer: Bool) -> (UIViewController, SecondModuleInput)
    func ipadModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String, withTimer: Bool) -> (UIViewController, SecondModuleInput)
}
