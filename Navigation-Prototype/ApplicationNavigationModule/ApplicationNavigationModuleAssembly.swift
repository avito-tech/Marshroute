import Foundation
import UIKit

protocol ApplicationNavigationModuleAssembly {
    func module() -> (UIViewController, ApplicationNavigationModuleModuleInput)
}
