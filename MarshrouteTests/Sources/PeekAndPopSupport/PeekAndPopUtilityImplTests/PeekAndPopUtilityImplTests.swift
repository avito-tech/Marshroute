import XCTest
@testable import Marshroute
import UIKit.UIGestureRecognizerSubclass

private let asyncTimeout: TimeInterval = 0.1

final class PeekAndPopUtilityImplTests: XCTestCase {
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
    
    func testPeekAndPopUtility_doesNotNotifyRegisteredViewController_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        expectation.isInverted = true
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                expectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesRegisteredViewController_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
       
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                expectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
    
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_doesNotNotifyUnregisteredViewController_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        expectation.isInverted = true
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                expectation.fulfill()
            }
        )
        
        unregisterSourceViewControllerFromPreviwing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_doesNotNotifyUnregisteredViewController_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        expectation.isInverted = true
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                expectation.fulfill()
            }
        )
        
        unregisterSourceViewControllerFromPreviwing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_passesPeekViewControllerToUIKit_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility()
            }
        )
        
        // When
        let viewController = beginPeekOnRegisteredViewController()
        
        // Then
        XCTAssert(viewController === peekViewController)
    }
    
    func testPeekAndPopUtility_doesNotPassPeekViewControllerToUIKit_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility()
            }
        )
        
        // When
        let viewController = beginPeekOnRegisteredViewController()
        
        // Then
        XCTAssert(viewController === nil)
    }
    
    func testPeekAndPopUtility_invokesPopAction_ifSomeTransitionOccursNotDuringActivePeek() {
        // Given
        let expectation = self.expectation(description: "async expectation")
      
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing()
        
        // When
        passPeekViewControllerToPeekAndPopUtility(
            popAction: {
                expectation.fulfill()    
            }
        )
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_invokesPopAction_ifPeekBeginsOnOffscreenRegisteredViewControllerAndSomeTransitionOccurs() {
        // Given
        let expectation = self.expectation(description: "async expectation")
      
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        passPeekViewControllerToPeekAndPopUtility(
            popAction: {
                expectation.fulfill()    
            }
        )
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_doesNotInvokePopAction_ifPeekDidBeginButDidNotCommitOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        expectation.isInverted = true
      
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility(
                    popAction:  {
                        expectation.fulfill()
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_invokesPopAction_ifPeekDidCommitOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility(
                    popAction:  {
                        expectation.fulfill()
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        commitPickOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_doesNotInvokePopAction_ifPeekGetsInterruptedWithAnotherTransitionOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        expectation.isInverted = true
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility(
                    popAction:  {
                        expectation.fulfill()
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        interruptPeekWithAnotherTransitionOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_doesNotInvokePopAction_ifPeekGetsCancelledByUserOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation(description: "async expectation")
        expectation.isInverted = true
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility(
                    popAction:  {
                        expectation.fulfill()
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        cancelPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekGetsInterruptedWithAnotherTransitionOnscreenRegisteredViewController() {
        // Given     
        weak var weakPeekViewController = peekViewController
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility()
                self.peekViewController = nil
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        interruptPeekWithAnotherTransitionOnRegisteredViewController()
        
        // Then
        XCTAssert(weakPeekViewController == nil)
    }
    
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekGetsCancelledByUserOnOnscreenRegisteredViewController() {
        // Given     
        weak var weakPeekViewController = peekViewController
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.passPeekViewControllerToPeekAndPopUtility()
                self.peekViewController = nil
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        cancelPeekOnRegisteredViewController()
        
        // Then
        XCTAssert(weakPeekViewController == nil)
    }
    
    // MARK: - Private
    private func unbindSourceViewControllerFromWindow() {
        window.rootViewController = nil
        sourceView?.removeFromSuperview()
    }
    
    private func bindSourceViewControllerToWindow() {
        window.rootViewController = sourceViewController!
        window.addSubview(sourceView)
    }
    
    private func registerSourceViewControllerForPreviewing(
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
    
    private func unregisterSourceViewControllerFromPreviwing() {
        peekAndPopUtility.unregister(
            viewController: sourceViewController,
            fromPreviewingInSourceView: sourceView
        )
    }
    
    @discardableResult
    private func beginPeekOnRegisteredViewController() -> UIViewController? {
        return peekAndPopUtility.previewingContext(
            previewingContext!,
            viewControllerForLocation: .zero
        )
    }
    
    private func commitPickOnRegisteredViewController() {
        peekAndPopUtility.previewingContext(
            previewingContext!,
            commit: peekViewController!
        )
    }
    
    private func interruptPeekWithAnotherTransitionOnRegisteredViewController() {
        passPeekInterruptingViewControllerToPeekAndPopUtility()
    }
    
    private func cancelPeekOnRegisteredViewController() {
        previewingContext?.previewingGestureRecognizerForFailureRelationship.state = .ended
    }
    
    private func passPeekViewControllerToPeekAndPopUtility(popAction: @escaping (() -> ()) = {}) {
        peekAndPopUtility.coordinatePeekIfNeededFor(
            viewController: peekViewController!,
            popAction: popAction
        )
    }
    
    private func passPeekInterruptingViewControllerToPeekAndPopUtility(popAction: @escaping (() -> ()) = {}) {
        peekAndPopUtility.coordinatePeekIfNeededFor(
            viewController: peekInterruptingViewController!,
            popAction: popAction
        )
    }
}

final class TestablePeekAndPopViewController: UIViewController {
    override func registerForPreviewing(
        with delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView)
        -> UIViewControllerPreviewing
    {
        return DummyViewControllerPreviewing(
            delegate: delegate,
            sourceView: sourceView
        )
    }
}

private class DummyViewControllerPreviewing: NSObject, UIViewControllerPreviewing {
    @available(iOS 9.0, *)
    var sourceRect: CGRect {
        get { return _sourceRect }
        set { _sourceRect = newValue }
    }

    let previewingGestureRecognizerForFailureRelationship: UIGestureRecognizer = TestableGestureRecognizer()
    var _sourceRect: CGRect = .zero
    let delegate: UIViewControllerPreviewingDelegate 
    let sourceView: UIView
    
    init(
        delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView)
    {
        self.delegate = delegate
        self.sourceView = sourceView
        
        super.init()
    }
}

private class TestableGestureRecognizer: UIGestureRecognizer {
    weak var target: AnyObject?
    var action: Selector?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: nil, action: nil)
        self.target = target as AnyObject
        self.action = action
    }
    
    override func addTarget(_ target: Any, action: Selector) {
        self.target = target as AnyObject
        self.action = action
        super.addTarget(target, action: action)
    }
    
    override func removeTarget(_ target: Any?, action: Selector?) {
        self.target = nil
        self.action = nil
        super.removeTarget(target, action: action)
    }
    
    override var state: UIGestureRecognizerState {
        didSet {
            if let target = target, let action = action {
                _ = target.perform(action, with: self)
            }
        }
    }
}
