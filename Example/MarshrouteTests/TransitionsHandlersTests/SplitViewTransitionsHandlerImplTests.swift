import XCTest
@testable import Marshroute

final class SplitViewTransitionsHandlerImplTests: XCTestCase {
    
    var transitionsCoordinatorSpy: TransitionsCoordinatorSpy!
    var splitViewTransitionsHandler: SplitViewTransitionsHandlerImpl!
    var splitViewController = UISplitViewController()
    
    override func setUp() {
        super.setUp()
        
        transitionsCoordinatorSpy = TransitionsCoordinatorSpy()
        
        splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinatorSpy
        )
    }
    
    // MARK: - TransitionsHandler
    
    func testThatSplitViewTransitionsHandlerForwards_PerformTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let presentationContext = TransitionContextsCreator.createPresentationTransitionContext()
        
        // When
        splitViewTransitionsHandler.performTransition(context: presentationContext)
        
        // Then
        if case .forContaining(let context, let transitionsHandler) = transitionsCoordinatorSpy.coordinatePerformingTransition! {
            XCTAssert(context == presentationContext)
            XCTAssert(transitionsHandler === splitViewTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatSplitViewTransitionsHandlerForwards_UndoTransitionsAfter_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        splitViewTransitionsHandler.undoTransitionsAfter(transitionId: generatedTansitionId)
        
        // Then
        if case .forContaining(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionsAfter! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === splitViewTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatSplitViewTransitionsHandlerForwards_UndoTransitionWith_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        splitViewTransitionsHandler.undoTransitionWith(transitionId: generatedTansitionId)
        
        // Then
        if case .forContaining(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionWith! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === splitViewTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatSplitViewTransitionsHandlerDoesNotForward_UndoAllChainedTransitions_CallsToItsTransitionsCoordinator() {
        // When
        splitViewTransitionsHandler.undoAllChainedTransitions()
        
        // Then
        XCTAssertNil(transitionsCoordinatorSpy.coordinateUndoingAllChainedTransitions)
    }
    
    func testThatSplitViewTransitionsHandlerDoesNotForward_UndoAllTransitions_CallsToItsTransitionsCoordinator() {
        // When
        splitViewTransitionsHandler.undoAllTransitions()
        
        // Then
        XCTAssertNil(transitionsCoordinatorSpy.coordinateUndoingAllChainedTransitions)
    }
    
    func testThatSplitViewTransitionsHandlerDoesNotForward_ResetWithTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let resettingContext = TransitionContextsCreator.createRegisteringEndpointNavigationControllerTransitionContext()
        
        // When
        splitViewTransitionsHandler.resetWithTransition(context: resettingContext)
        
        // Then
        XCTAssertNil(transitionsCoordinatorSpy.coordinateResettingWithTransition)
    }
    
    // MARK: - TransitionsHandlerContainer
    
    func testThatSplitViewTransitionsHandlerReturnsAllTransitionsHandlersOn_AllTransitionsHandlers_Call() {
        // Given
        let masterTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        let detailTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        // When
        let allTransitionsHandlers = splitViewTransitionsHandler.allTransitionsHandlers!
        
        // Then
        XCTAssertNotNil(allTransitionsHandlers.index() { $0 === masterTransitionsHandler })
        XCTAssertNotNil(allTransitionsHandlers.index() { $0 === detailTransitionsHandler })
    }
    
    func testThatSplitViewTransitionsHandlerReturnsAllTransitionsHandlersOn_VisibleTransitionsHandlers_Call() {
        // Given
        let masterTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        let detailTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        // When
        let visibleTransitionsHandlers = splitViewTransitionsHandler.visibleTransitionsHandlers!
        
        // Then
        XCTAssertNotNil(visibleTransitionsHandlers.index() { $0 === masterTransitionsHandler })
        XCTAssertNotNil(visibleTransitionsHandlers.index() { $0 === detailTransitionsHandler })
    }
}
