import UIKit

protocol TopViewControllerFindingService: AnyObject {
    func topViewControllerAndItsContainerViewController()
        -> (UIViewController, UIViewController)?
}
