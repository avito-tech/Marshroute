import XCTest
@testable import Marshroute
import UIKit.UIGestureRecognizerSubclass

class BasePeekAndPopUtilityImplTestCase: XCTestCase {
    let asyncTimeout: TimeInterval = 0.1
    
    var peekAndPopUtility: PeekAndPopUtilityImpl!
    var sourceViewController: UIViewController!
    var sourceView: UIView!
    var window: UIWindow!
    var previewingContext: UIViewControllerPreviewing?
    var peekViewController: UIViewController?
    var peekNavigationController: UINavigationController?
    var peekInterruptingViewController: UIViewController!

    override func setUp() {
        super.setUp()
        peekAndPopUtility = PeekAndPopUtilityImpl()
        sourceViewController = TestablePeekAndPopViewController()
        sourceView = sourceViewController.view
        window = UIWindow()
        peekViewController = UIViewController()
        peekNavigationController = UINavigationController(rootViewController: peekViewController!)
        peekInterruptingViewController = UIViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        peekAndPopUtility = nil
        sourceViewController = nil
        sourceView = nil
        window = nil
        previewingContext = nil
        peekViewController = nil
        peekNavigationController = nil
        peekInterruptingViewController = nil
    }
        
    // MARK: - Internal
    func unbindSourceViewControllerFromWindow() {
        window.rootViewController = nil
        sourceView.removeFromSuperview()
    }
    
    func bindSourceViewControllerToWindow() {
        window.rootViewController = sourceViewController
        window.addSubview(sourceView)
    }
    
    func registerSourceViewControllerForPreviewing(
        onPeek: ((_ previewingContext: UIViewControllerPreviewing) -> ())? = nil)
    {
        peekAndPopUtility.register(
            viewController: sourceViewController,
            forPreviewingInSourceView: sourceView,
            onPeek: { previewingContext, _ in 
                onPeek?(previewingContext)
            },
            onPreviewingContextChange: { [weak self] previewingContext in
                self?.previewingContext = previewingContext
            }
        )
    }
    
    func unregisterSourceViewControllerFromPreviewing() {
        peekAndPopUtility.unregister(
            viewController: sourceViewController,
            fromPreviewingInSourceView: sourceView
        )
    }
    
    func subscribeForPeekAndPopStateChanges(
        onPeekAndPopStateChange: @escaping ((_ viewController: UIViewController, _ peekAndPopState: PeekAndPopState) -> ()))
    {
        peekAndPopUtility.addObserver(
            disposable: self,
            onPeekAndPopStateChange: onPeekAndPopStateChange
        )
    }
    
    @discardableResult
    func beginPeekOnRegisteredViewController() -> UIViewController? {
        return peekAndPopUtility.previewingContext(
            previewingContext!,
            viewControllerForLocation: .zero
        )
    }
    
    func commitPickOnRegisteredViewController() {
        peekAndPopUtility.previewingContext(
            previewingContext!,
            commit: peekViewController!
        )
    }
    
    func cancelPeekOnRegisteredViewController() {
        previewingContext?.previewingGestureRecognizerForFailureRelationship.state = .ended
    }
    
    func interruptPeekWithAnotherTransitionOnRegisteredViewController() {
        invokeTransitionToPeekInterruptingViewController()
    }
    
    func invokeTransitionToPeekViewController(popAction: @escaping (() -> ()) = {}) {
        peekAndPopUtility.coordinatePeekIfNeededFor(
            viewController: peekViewController!,
            popAction: popAction
        )
    }
    
    func invokeTransitionToPeekInterruptingViewController(popAction: @escaping (() -> ()) = {}) {
        peekAndPopUtility.coordinatePeekIfNeededFor(
            viewController: peekInterruptingViewController!,
            popAction: popAction
        )
    }
    
    func expectation() -> XCTestExpectation {
        return expectation(description: "async expectation")
    }
    
    func invertedExpectation() -> XCTestExpectation {
        let result = expectation(description: "inverted async expectation")
        result.isInverted = true
        return result
    }
}
