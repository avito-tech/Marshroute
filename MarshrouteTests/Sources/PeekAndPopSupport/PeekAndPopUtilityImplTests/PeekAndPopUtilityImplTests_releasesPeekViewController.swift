import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_releasesPeekViewController: BasePeekAndPopUtilityImplTestCase {    
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
        
        // Then
        DispatchQueue.main.async {
            XCTAssert(weakPeekViewController == nil)
            expectation.fulfill()            
        }
        
        waitForExpectations(timeout: asyncTimeout)
    }
    
    func testPeekAndPopUtility_releasesPeekViewController_ifPeekGetsInterruptedWithAnotherTransitionOnOnscreenRegisteredViewController() {
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
        
        // Then
        DispatchQueue.main.async {
            XCTAssert(weakPeekViewController == nil)
            expectation.fulfill()            
        }
        
        waitForExpectations(timeout: asyncTimeout)
    }
}    
