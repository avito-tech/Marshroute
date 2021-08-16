import UIKit

/// Методы для создания кастомных UIKit контроллеров представлений
public protocol RouterControllersProvider: AnyObject {
    func navigationController() -> UINavigationController
    func splitViewController() -> UISplitViewController
}
