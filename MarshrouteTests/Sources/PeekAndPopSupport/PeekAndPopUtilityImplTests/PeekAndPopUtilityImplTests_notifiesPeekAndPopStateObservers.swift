import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_notifiesPeekAndPopStateObservers: BasePeekAndPopUtilityImplTestCase {    
    func testPeekAndPopUtility_notifiesPeekAndPopStateObservers_ifPeekGetsCommitedOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        var callbackCounter = 0

        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { viewController, peekAndPopState in
                callbackCounter += 1
                expectation.fulfill()
                
                if callbackCounter == 2 {
                    XCTAssert(viewController === self.peekViewController)
                    XCTAssert(peekAndPopState == .popped)
                }
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        commitPickOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesPeekAndPopStateObservers_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { viewController, peekAndPopState in
                XCTAssert(viewController === self.peekViewController)
                XCTAssert(peekAndPopState == .inPeek)
                expectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesPeekAndPopStateObservers_ifPeekGetsInterruptedWithAnotherTransitionOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        var callbackCounter = 0

        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { viewController, peekAndPopState in
                callbackCounter += 1
                expectation.fulfill()
                
                if callbackCounter == 2 {
                    XCTAssert(viewController === self.peekViewController)
                    XCTAssert(peekAndPopState == .interrupted)
                }
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        interruptPeekWithAnotherTransitionOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesPeekAndPopStateObservers_ifPeekGetsCommitedOnOnscreenRegisteredViewControllerWithNotPeekViewController() {
        // Given
        let expectation = self.expectation()
        expectation.expectedFulfillmentCount = 2
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        var callbackCounter = 0
        
        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { viewController, peekAndPopState in
                callbackCounter += 1
                expectation.fulfill()
                
                if callbackCounter == 2 {
                    XCTAssert(viewController === self.peekViewController)
                    XCTAssert(peekAndPopState == .interrupted)
                }
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        commitPickOnRegisteredViewControllerToNotPeekViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNewPeekAndPopStateObserversImmediately_ifPeekIsInProgress() {
        // Given
        let expectation = self.expectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { viewController, peekAndPopState in
                XCTAssert(viewController === self.peekViewController)
                XCTAssert(peekAndPopState == .inPeek)
                
                expectation.fulfill()
            }
        )
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoPeekAndPopStateObservers_ifSomeTransitionOccursNotDuringActivePeek() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing()
        
        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { _, _ in
                invertedExpectation.fulfill()
            }
        )
        
        // When
        invokeTransitionToPeekViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoPeekAndPopStateObservers_ifPeekBeginsOnOffscreenRegisteredViewControllerAndSomeTransitionOccurs() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing()
        
        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { _, _ in
                invertedExpectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        invokeTransitionToPeekViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoPeekAndPopStateObservers_ifPeekBeginsOnOnscreenRegisteredViewControllerWithNotNavigationParentViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        bindPeekViewControllerToAnotherParent()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        subscribeForPeekAndPopStateChanges(
            onPeekAndPopStateChange: { _, _ in
                invertedExpectation.fulfill()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
}    
