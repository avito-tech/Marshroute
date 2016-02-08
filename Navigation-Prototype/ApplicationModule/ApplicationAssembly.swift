import UIKit

protocol ApplicationAssembly {
    func sharedModule() -> (viewController: UIViewController, moduleInput: ApplicationModuleInput)
}
