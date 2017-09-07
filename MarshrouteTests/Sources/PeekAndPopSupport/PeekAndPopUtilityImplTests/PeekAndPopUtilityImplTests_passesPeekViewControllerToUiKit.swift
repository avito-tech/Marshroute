import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_passesPeekViewControllerToUiKit: BasePeekAndPopUtilityImplTestCase {    
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
    
    func testPeekAndPopUtility_passesPeekViewControllerToUIKit_ifSamePeekFailedToBeginAndNewPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        bindSourceViewControllerToWindow()
        
        bindSourceViewController2ToWindow()
        
        registerSourceViewControllerForPreviewing()
        
        registerSourceViewController2ForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        // When
        beginPeekOnRegisteredViewController()
        
        let viewController2 = beginPeekOnRegisteredViewController2()
        
        // Then
        XCTAssert(viewController2 === peekViewController)
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
    
    func testPeekAndPopUtility_passesNoPeekViewControllerToUIKit_ifSamePeekIsAlreadyBeganAndNewPeekBeginsOnOnscreenRegisteredViewController() {
        // Given
        bindSourceViewControllerToWindow()
       
        bindSourceViewController2ToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController()
            }
        )
        
        registerSourceViewController2ForPreviewing()
        
        // When
        beginPeekOnRegisteredViewController()
        
        let viewController2 = beginPeekOnRegisteredViewController2()
        
        // Then
        XCTAssert(viewController2 === nil)
    }
}    
