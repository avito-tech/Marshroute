import UIKit

public protocol TopViewControllerFinder: AnyObject {
    func findTopViewController(animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
        -> UIViewController?
    func findTopViewController(containingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> UIViewController?
}
