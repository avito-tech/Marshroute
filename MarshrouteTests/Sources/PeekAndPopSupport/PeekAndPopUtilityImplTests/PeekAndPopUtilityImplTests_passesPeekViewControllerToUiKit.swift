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
}    
