import UIKit

protocol Router: class {
    weak var rootViewController: UIViewController? { get }
    func setRootViewControllerIfNeeded(controller: UIViewController)
}
