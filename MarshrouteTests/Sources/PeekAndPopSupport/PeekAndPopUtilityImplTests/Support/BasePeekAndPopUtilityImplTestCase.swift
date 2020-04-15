import XCTest
@testable import Marshroute
import UIKit.UIGestureRecognizerSubclass

class BasePeekAndPopUtilityImplTestCase: XCTestCase {
    let asyncTimeout: TimeInterval = 0.5
    let asyncDelay: TimeInterval = 0.1
    
    var peekAndPopUtility: PeekAndPopUtilityImpl!
    var sourceViewController: TestablePeekAndPopSourceViewController!
    var sourceView: UIView!
    var otherSourceView: UIView!
    var sourceViewController2: TestablePeekAndPopSourceViewController!
    var sourceView2: UIView!
    var window: UIWindow!
    var previewingContext: UIViewControllerPreviewing?
    var previewingContext2: UIViewControllerPreviewing?
    var peekViewController: UIViewController?
    var peekNavigationController: UINavigationController?
    var peekViewControllerAnotherParentViewController: UIViewController!
    var peekInterruptingViewController: UIViewController!

    override func setUp() {
        super.setUp()
        peekAndPopUtility = PeekAndPopUtilityImpl()
        sourceViewController = TestablePeekAndPopSourceViewController()
        sourceView = sourceViewController.view
        otherSourceView = UIView()
        sourceViewController2 = TestablePeekAndPopSourceViewController()
        sourceView2 = sourceViewController2.view
        window = UIWindow()
        peekViewController = UIViewController()
        peekNavigationController = UINavigationController(rootViewController: peekViewController!)
        peekViewControllerAnotherParentViewController = UIViewController()
        peekInterruptingViewController = UIViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        peekAndPopUtility = nil
        sourceViewController = nil
        sourceView = nil
        otherSourceView = nil
        sourceViewController2 = nil
        sourceView2 = nil
        window = nil
        previewingContext = nil
        previewingContext2 = nil
        peekViewController = nil
        peekNavigationController = nil
        peekViewControllerAnotherParentViewController = nil
        peekInterruptingViewController = nil
    }
        
    // MARK: - Internal
    func unbindSourceViewControllerFromWindow() {
        window.rootViewController = nil
        sourceView.removeFromSuperview()
    }
    
    func bindSourceViewControllerToWindow() {
        window.addSubview(sourceView)
    }
    
    func bindSourceViewController2ToWindow() {
        window.addSubview(sourceView2)
    }
    
    func bindPeekViewControllerToAnotherParent() {
        peekNavigationController?.viewControllers = []
        peekViewControllerAnotherParentViewController!.addChild(peekViewController!)
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
    
    func registerSourceViewControllerForPreviewingWithOtherSourceView(
        onPeek: ((_ previewingContext: UIViewControllerPreviewing) -> ())? = nil)
    {
        peekAndPopUtility.register(
            viewController: sourceViewController,
            forPreviewingInSourceView: otherSourceView,
            onPeek: { previewingContext, _ in 
                onPeek?(previewingContext)
        },
            onPreviewingContextChange: { [weak self] previewingContext in
                self?.previewingContext = previewingContext
            }
        )
    }
    
    func registerSourceViewController2ForPreviewing(
        onPeek: ((_ previewingContext: UIViewControllerPreviewing) -> ())? = nil)
    {
        peekAndPopUtility.register(
            viewController: sourceViewController2,
            forPreviewingInSourceView: sourceView2,
            onPeek: { previewingContext, _ in 
                onPeek?(previewingContext)
            },
            onPreviewingContextChange: { [weak self] previewingContext in
                self?.previewingContext2 = previewingContext
            }
        )
    }
    
    func unregisterSourceViewControllerFromPreviewing() {
        peekAndPopUtility.unregister(
            viewController: sourceViewController,
            fromPreviewingInSourceView: sourceView
        )
    }
    
    func unregisterSourceViewControllerFromPreviewingWithOtherSourceView() {
        peekAndPopUtility.unregister(
            viewController: sourceViewController,
            fromPreviewingInSourceView: otherSourceView
        )
    }
    
    func unregisterSourceViewControllerFromPreviewingInAllSourceViews() {
        peekAndPopUtility.unregisterViewControllerFromPreviewingInAllSourceViews(
            sourceViewController
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
    
    private let peekLocation = CGPoint(x: 100, y: 100)
    
    @discardableResult
    func beginPeekOnRegisteredViewController() -> UIViewController? {
        return peekAndPopUtility.previewingContext(
            previewingContext!,
            viewControllerForLocation: peekLocation
        )
    }
    
    @discardableResult
    func beginPeekOnRegisteredViewController2() -> UIViewController? {
        return peekAndPopUtility.previewingContext(
            previewingContext2!,
            viewControllerForLocation: peekLocation
        )
    }
    
    func commitPickOnRegisteredViewController() {
        peekAndPopUtility.previewingContext(
            previewingContext!,
            commit: peekViewController!
        )
    }
    
    func commitPickOnRegisteredViewController2() {
        peekAndPopUtility.previewingContext(
            previewingContext2!,
            commit: peekViewController!
        )
    }
    
    func commitPickOnRegisteredViewControllerToNotPeekViewController() {
        peekAndPopUtility.previewingContext(
            previewingContext!,
            commit: UIViewController()
        )   
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
