import UIKit

/// Методы для создания кастомных UIKit контроллеров представлений
public protocol RouterControllersProvider: class {
    func navigationController() -> UINavigationController
    func splitViewController() -> UISplitViewController
}
