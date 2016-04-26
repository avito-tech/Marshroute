import XCTest

final class AnimatingTransitionsHandlerTests: XCTestCase {

    var transitionsCoordinatorSpy: TransitionsCoordinatorSpy!
    var animatingTransitionsHandler: AnimatingTransitionsHandler!
    
    override func setUp() {
        super.setUp()
        
        transitionsCoordinatorSpy = TransitionsCoordinatorSpy()
        
        animatingTransitionsHandler = AnimatingTransitionsHandler(
            transitionsCoordinator: transitionsCoordinatorSpy
        )
    }
    
    // MARK: - TransitionsHandler
    
    func testThatAnimatingTransitionsHandlerForwards_PerformTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let presentationContext = TransitionContextsCreator.createPresentationTransitionContext()
        
        // When
        animatingTransitionsHandler.performTransition(context: presentationContext)
        
        // Then
        if case .ForAnimating(let context, let transitionsHandler) = transitionsCoordinatorSpy.coordinatePerformingTransition! {
            XCTAssert(context == presentationContext)
            XCTAssert(transitionsHandler === animatingTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatAnimatingTransitionsHandlerForwards_UndoTransitionsAfter_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        animatingTransitionsHandler.undoTransitionsAfter(transitionId: generatedTansitionId)
        
        // Then
        if case .ForAnimating(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionsAfter! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === animatingTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatAnimatingTransitionsHandlerForwards_UndoTransitionWith_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        animatingTransitionsHandler.undoTransitionWith(transitionId: generatedTansitionId)
        
        // Then
        if case .ForAnimating(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionWith! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === animatingTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatAnimatingTransitionsHandlerForwards_UndoAllChainedTransitions_CallsToItsTransitionsCoordinator() {
        // When
        animatingTransitionsHandler.undoAllChainedTransitions()
        
        // Then
        if case .ForAnimating(let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingAllChainedTransitions! {
            XCTAssert(transitionsHandler === animatingTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatAnimatingTransitionsHandlerForwards_UndoAllTransitions_CallsToItsTransitionsCoordinator() {
        // When
        animatingTransitionsHandler.undoAllTransitions()
        
        // Then
        if case .ForAnimating(let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingAllTransitions! {
            XCTAssert(transitionsHandler === animatingTransitionsHandler)
        } else { XCTFail() }
    }

    func testThatAnimatingTransitionsHandlerForwards_ResetWithTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let resettingContext = TransitionContextsCreator.createRegisteringEndpointNavigationControllerTransitionContext()
        
        // When
        animatingTransitionsHandler.resetWithTransition(context: resettingContext)
        
        // Then
        if case .ForAnimating(let context, let transitionsHandler) = transitionsCoordinatorSpy.coordinateResettingWithTransition! {
            XCTAssert(context == resettingContext)
            XCTAssert(transitionsHandler === animatingTransitionsHandler)
        } else { XCTFail() }
    }
}
