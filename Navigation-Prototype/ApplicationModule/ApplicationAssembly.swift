import UIKit

protocol ApplicationAssembly {
    func module() -> (viewController: UIViewController, moduleInput: ApplicationModuleInput)
}
