import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_passesPreviewingContextToRegisteredViewController: BasePeekAndPopUtilityImplTestCase {    
    func testPeekAndPopUtility_passesPreviewingContextToRegisteredViewController_ifViewControllerRegistersForPreviewing() {
        // When
        registerSourceViewControllerForPreviewing()
        
        // Then
        XCTAssert(previewingContext != nil)
    }

    func testPeekAndPopUtility_passesPreviewingContextToRegisteredViewController_ifViewControllerReregistersForPreviewing() {
        // When
        registerSourceViewControllerForPreviewing()
        
        unregisterSourceViewControllerFromPreviewing()
        
        previewingContext = nil
        
        registerSourceViewControllerForPreviewing()
        
        // Then
        XCTAssert(previewingContext != nil)
    }
    
    func testPeekAndPopUtility_passesPreviewingContextToRegisteredViewController_ifPeekGetsInterruptedWithAnotherTransitionOnOnscreenRegisteredViewController() {
        // Given
        bindSourceViewControllerToWindow()
        
        registerSourceViewControllerForPreviewing(
            onPeek: { _ in
                self.invokeTransitionToPeekViewController() 
            }
        )
        
        let previousPreviewingContext = previewingContext
        
        // When
        beginPeekOnRegisteredViewController()
        
        interruptPeekWithAnotherTransitionOnRegisteredViewController()
        
        // Then
        XCTAssert(previewingContext !== previousPreviewingContext)
    }
}    
