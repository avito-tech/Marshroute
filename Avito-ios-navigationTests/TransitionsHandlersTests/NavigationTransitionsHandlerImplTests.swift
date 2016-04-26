import XCTest

final class NavigationTransitionsHandlerImplTests: XCTestCase {

    var transitionsCoordinatorSpy: TransitionsCoordinatorSpy!
    var navigationTransitionsHandler: NavigationTransitionsHandlerImpl!
    var navigationController = UINavigationController()
    
    override func setUp() {
        super.setUp()
        
        transitionsCoordinatorSpy = TransitionsCoordinatorSpy()
        
        navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinatorSpy
        )
    }
    
    // MARK: - TransitionsHandler
    
    func testThatNavigationTransitionsHandlerForwards_PerformTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let presentationContext = TransitionContextsCreator.createPresentationTransitionContext()
        
        // When
        navigationTransitionsHandler.performTransition(context: presentationContext)
        
        // Then
        if case .ForAnimating(let context, let transitionsHandler) = transitionsCoordinatorSpy.coordinatePerformingTransition! {
            XCTAssert(context == presentationContext)
            XCTAssert(transitionsHandler === navigationTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatNavigationTransitionsHandlerForwards_UndoTransitionsAfter_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        navigationTransitionsHandler.undoTransitionsAfter(transitionId: generatedTansitionId)
        
        // Then
        if case .ForAnimating(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionsAfter! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === navigationTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatNavigationTransitionsHandlerForwards_UndoTransitionWith_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        navigationTransitionsHandler.undoTransitionWith(transitionId: generatedTansitionId)
        
        // Then
        if case .ForAnimating(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionWith! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === navigationTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatNavigationTransitionsHandlerForwards_UndoAllChainedTransitions_CallsToItsTransitionsCoordinator() {
        // When
        navigationTransitionsHandler.undoAllChainedTransitions()
        
        // Then
        if case .ForAnimating(let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingAllChainedTransitions! {
            XCTAssert(transitionsHandler === navigationTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatNavigationTransitionsHandlerForwards_UndoAllTransitions_CallsToItsTransitionsCoordinator() {
        // When
        navigationTransitionsHandler.undoAllTransitions()
        
        // Then
        if case .ForAnimating(let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingAllTransitions! {
            XCTAssert(transitionsHandler === navigationTransitionsHandler)
        } else { XCTFail() }
    }

    func testThatNavigationTransitionsHandlerForwards_ResetWithTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let resettingContext = TransitionContextsCreator.createRegisteringEndpointNavigationControllerTransitionContext()
        
        // When
        navigationTransitionsHandler.resetWithTransition(context: resettingContext)
        
        // Then
        if case .ForAnimating(let context, let transitionsHandler) = transitionsCoordinatorSpy.coordinateResettingWithTransition! {
            XCTAssert(context == resettingContext)
            XCTAssert(transitionsHandler === navigationTransitionsHandler)
        } else { XCTFail() }
    }
}
