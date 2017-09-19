import XCTest
@testable import Marshroute

final class PeekAndPopUtilityImplTests_registersViewControllerForPreviewing: BasePeekAndPopUtilityImplTestCase {    
    func testPeekAndPopUtility_registersViewControllerForPreviewing_ifViewControllerWasNotRegisteredBefore() {
        // When
        sourceViewController.shouldStartSpying = true
        registerSourceViewControllerForPreviewing()

        // Then
        XCTAssert(sourceViewController.registerForPreviewingCalledCount == 1)
        XCTAssert(sourceViewController.unregisterForPreviewingCalledCount == 0)
    }
    
    func testPeekAndPopUtility_reregistersViewControllerForPreviewing_ifViewControllerWasRegisteredBeforeWithSameView() {
        // Given
        registerSourceViewControllerForPreviewing()
        
        // When
        sourceViewController.shouldStartSpying = true
        registerSourceViewControllerForPreviewing()
        
        // Then
        XCTAssert(sourceViewController.registerForPreviewingCalledCount == 1)
        XCTAssert(sourceViewController.unregisterForPreviewingCalledCount == 1)
    }
    
    func testPeekAndPopUtility_registersViewControllerForPreviewing_ifViewControllerWasRegisteredBeforeWithOtherView() {
        // Given
        registerSourceViewControllerForPreviewing()
        
        // When
        sourceViewController.shouldStartSpying = true
        registerSourceViewControllerForPreviewingWithOtherSourceView()
        
        // Then
        XCTAssert(sourceViewController.registerForPreviewingCalledCount == 1)
        XCTAssert(sourceViewController.unregisterForPreviewingCalledCount == 0)
    }
    
    func testPeekAndPopUtility_unregistersViewControllerFromPreviewing_ifViewControllerWasRegisteredBeforeWithSameView() {
        // Given
        registerSourceViewControllerForPreviewing()
        
        // When
        sourceViewController.shouldStartSpying = true
        unregisterSourceViewControllerFromPreviewing()
        
        // Then
        XCTAssert(sourceViewController.registerForPreviewingCalledCount == 0)
        XCTAssert(sourceViewController.unregisterForPreviewingCalledCount == 1)
    }
    
    func testPeekAndPopUtility_unregistersNoViewControllerFromPreviewing_ifViewControllerWasRegisteredBeforeWithOtherView() {
        // Given
        registerSourceViewControllerForPreviewing()
        
        // When
        sourceViewController.shouldStartSpying = true
        unregisterSourceViewControllerFromPreviewingWithOtherSourceView()
        
        // Then
        XCTAssert(sourceViewController.registerForPreviewingCalledCount == 0)
        XCTAssert(sourceViewController.unregisterForPreviewingCalledCount == 0)
    }
    
    func testPeekAndPopUtility_unregistersViewControllerFromPreviewing_ifViewControllerWasRegisteredBeforeWithManyViews() {
        // Given
        registerSourceViewControllerForPreviewing()
        registerSourceViewControllerForPreviewingWithOtherSourceView()
        
        // When
        sourceViewController.shouldStartSpying = true
        unregisterSourceViewControllerFromPreviewingInAllSourceViews()
        
        // Then
        XCTAssert(sourceViewController.registerForPreviewingCalledCount == 0)
        XCTAssert(sourceViewController.unregisterForPreviewingCalledCount == 2)
    }
}    
