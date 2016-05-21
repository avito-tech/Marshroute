import UIKit

public protocol TopViewControllerFinder: class {
    func findTopViewController(animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
        -> UIViewController?
    func findTopViewController(containingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> UIViewController?
}
