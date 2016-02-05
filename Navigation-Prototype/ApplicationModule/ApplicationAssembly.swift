import UIKit

protocol ApplicationAssembly {
    func module() -> (UIViewController, ApplicationModuleInput)
}
