import UIKit

/// Методы для создания кастомных UIKit контроллеров представлений
public protocol RouterControllersProvider: AnyObject {
    // Тут тоже можно закрыть протоколом, но пока не сталкивались со случаем написания своего UINavigationController
    func navigationController() -> UINavigationController

    func splitViewController() -> SplitViewControllerProtocol & UIViewController

    func tabBarViewController() -> TabBarControllerProtocol & UIViewController
}
