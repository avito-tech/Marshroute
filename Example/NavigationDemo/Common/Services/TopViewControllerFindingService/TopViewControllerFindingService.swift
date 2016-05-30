import UIKit

protocol TopViewControllerFindingService: class {
    func topViewControllerAndItsContainerViewController()
        -> (UIViewController, UIViewController)?
}