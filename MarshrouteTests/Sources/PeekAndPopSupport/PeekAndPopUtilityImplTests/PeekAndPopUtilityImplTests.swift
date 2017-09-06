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
    
    func testPeekAndPopUtility_notifiesRereregisteredViewController_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing()
        
        unregisterSourceViewControllerFromPreviwing()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                invertedExpectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoRegisteredViewController_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                invertedExpectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoUnregisteredViewController_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()

        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                invertedExpectation.fulfill()
            }
        )
        
        unregisterSourceViewControllerFromPreviwing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoUnregisteredViewController_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                invertedExpectation.fulfill()
            }
        )
        
        unregisterSourceViewControllerFromPreviwing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    
    
    func testPeekAndPopUtility_passesPeekViewControllerToUiKit_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        // When
        let viewController = beginPeekOnRegisteredViewController()
        
        // Then
        XCTAssert(viewController === peekViewController)
    }
    
    func testPeekAndPopUtility_passesNoPeekViewControllerToUIKit_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        // When
        let viewController = beginPeekOnRegisteredViewController()
        
        // Then
        XCTAssert(viewController === nil)
    }
    
    
    
    
    func testPeekAndPopUtility_invokesPopAction_ifSomeTransitionOccursNotDuringActivePeek() {
        // Given
        let expectation = self.expectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing()
        
        // When
        invokeTransitionToPeekViewController(
            popAction: {
                expectation.fulfill()    
            }
        )
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_invokesPopAction_ifPeekBeginsOnOffscreenRegisteredViewControllerAndSomeTransitionOccurs() {
        // Given
        let expectation = self.expectation()
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        invokeTransitionToPeekViewController(
            popAction: {
                expectation.fulfill()    
            }
        )
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_invokesPopAction_ifPeekGetsCommitedOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController(
                    popAction: {
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
    
    func testPeekAndPopUtility_invokesNoPopAction_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController(
                    popAction: {
                        invertedExpectation.fulfill()
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_invokesNoPopAction_ifPeekGetsInterruptedWithAnotherTransitionOnOnscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController(
                    popAction: {
                        invertedExpectation.fulfill()
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
    
    func testPeekAndPopUtility_invokesNoPopAction_ifPeekGetsCancelledByUserOnOnscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController(
                    popAction: {
                        invertedExpectation.fulfill()
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        cancelPeekOnRegisteredViewController()
        
        unbindSourceViewControllerFromWindow()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    
    
    
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekBeginsOnOffscreenRegisteredViewControllerAndSomeTransitionOccurs() {
        // Given
        let expectation = self.expectation()
        
        weak var weakPeekViewController = peekViewController
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        invokeTransitionToPeekViewController(
            popAction: {
                self.peekViewController = nil
                self.peekNavigationController?.viewControllers = []
            }
        )
        
        // Then
        DispatchQueue.main.async {
            XCTAssert(weakPeekViewController == nil)
            expectation.fulfill()            
        }
        
        waitForExpectations(timeout: asyncTimeout)
    }
        
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekGetsCommitedOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        
        weak var weakPeekViewController = peekViewController
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController(
                    popAction: {
                        self.peekViewController = nil
                        self.peekNavigationController?.viewControllers = []
                    }
                )
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        commitPickOnRegisteredViewController()
        
        unbindSourceViewControllerFromWindow()
        
        // Then
        DispatchQueue.main.async {
            XCTAssert(weakPeekViewController == nil)
            expectation.fulfill()            
        }
        
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekGetsInterruptedWithAnotherTransitionOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        
        weak var weakPeekViewController = peekViewController
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
                self.peekViewController = nil
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        interruptPeekWithAnotherTransitionOnRegisteredViewController()
        
        unbindSourceViewControllerFromWindow()
        
        // Then
        DispatchQueue.main.async {
            XCTAssert(weakPeekViewController == nil)
            expectation.fulfill()            
        }
        
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekGetsCancelledByUserOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        
        weak var weakPeekViewController = peekViewController
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
                self.peekViewController = nil
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        cancelPeekOnRegisteredViewController()
        
        unbindSourceViewControllerFromWindow()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(weakPeekViewController == nil)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: asyncTimeout)
    }
    
    // MARK: - Private
    private func unbindSourceViewControllerFromWindow() {
        window.rootViewController = nil
        sourceView.removeFromSuperview()
    }
    
    private func bindSourceViewControllerToWindow() {
        window.rootViewController = sourceViewController
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
    
    private func invokeTransitionToPeekViewController(popAction: @escaping (() -> ()) = {}) {
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
    
    private func expectation() -> XCTestExpectation {
        return expectation(description: "async expectation")
    }
    
    private func invertedExpectation() -> XCTestExpectation {
        let result = expectation(description: "inverted async expectation")
        result.isInverted = true
        return result
    }
}
