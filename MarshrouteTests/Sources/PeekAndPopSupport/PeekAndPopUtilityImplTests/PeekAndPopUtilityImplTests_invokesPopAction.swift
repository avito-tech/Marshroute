import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_invokesPopAction: BasePeekAndPopUtilityImplTestCase {    
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
    
    func testPeekAndPopUtility_invokesNoPopAction_ifPeekBeginsOnOnscreenRegisteredViewControllerWithNotNavigationParentViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        bindPeekViewControllerToAnotherParent()
        
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
    
    func testPeekAndPopUtility_invokesNoPopAction_ifPeekGetsCommitedOnOnscreenRegisteredViewControllerWithNotPeekViewController() {
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
        
        commitPickOnRegisteredViewControllerToNotPeekViewController()
        
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
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
}    
