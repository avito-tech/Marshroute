import UIKit

/// Методы для создания кастомных UIKit контроллеров представлений, используемых базовыми роутерами по-умолчанию
public protocol RouterControllersProvider: class {
    func navigationController() -> UINavigationController
    func splitViewController() -> UISplitViewController
}
