import UIKit

/**
 *  Методы, чтобы связать роутер с его главным экраном
 */
protocol Router: class {
    weak var rootViewController: UIViewController? { get }
    func setRootViewControllerIfNeeded(controller: UIViewController)
}
