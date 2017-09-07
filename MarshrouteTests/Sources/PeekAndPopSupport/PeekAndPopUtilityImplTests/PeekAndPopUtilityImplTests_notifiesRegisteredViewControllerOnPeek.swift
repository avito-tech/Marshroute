import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_notifiesRegisteredViewControllerOnPeek: BasePeekAndPopUtilityImplTestCase {    
    func testPeekAndPopUtility_notifiesRegisteredViewControllerOnPeek_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let expectation = self.expectation()
        
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
    
    func testPeekAndPopUtility_notifiesReregisteredViewControllerOnPeek_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing()
        
        unregisterSourceViewControllerFromPreviewing()
        
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
    
    func testPeekAndPopUtility_notifiesNoRegisteredViewControllerOnPeek_ifPeekBeginsOnOffscreenRegisteredViewController() {
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
    
    func testPeekAndPopUtility_notifiesNoUnregisteredViewControllerOnPeek_ifPeekBeginsOnOffscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()

        unbindSourceViewControllerFromWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                invertedExpectation.fulfill()
            }
        )
        
        unregisterSourceViewControllerFromPreviewing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_notifiesNoUnregisteredViewControllerOnPeek_ifPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        let invertedExpectation = self.invertedExpectation()
        
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                invertedExpectation.fulfill()
            }
        )
        
        unregisterSourceViewControllerFromPreviewing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        // Then
        waitForExpectations(timeout: asyncTimeout)
    }
}    
