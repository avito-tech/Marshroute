import UIKit

protocol AuthorizationAssembly {
    func module() -> (UIViewController, AuthorizationModuleInput)
}
