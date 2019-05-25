import XCTest
@testable import Marshroute

final class TabBarTransitionsHandlerImplTests: XCTestCase {

    var transitionsCoordinatorSpy: TransitionsCoordinatorSpy!
    var tabBarTransitionsHandler: TabBarTransitionsHandlerImpl!
    var tabBarController = UITabBarController()
    
    override func setUp() {
        super.setUp()
        
        transitionsCoordinatorSpy = TransitionsCoordinatorSpy()
        
        tabBarTransitionsHandler = TabBarTransitionsHandlerImpl(
            tabBarController: tabBarController,
            transitionsCoordinator: transitionsCoordinatorSpy
        )
    }
    
    // MARK: - TransitionsHandler
    
    func testThatTabBarTransitionsHandlerForwards_PerformTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let presentationContext = TransitionContextsCreator.createPresentationTransitionContext()
        
        // When
        tabBarTransitionsHandler.performTransition(context: presentationContext)
        
        // Then
        if case .forContaining(let context, let transitionsHandler) = transitionsCoordinatorSpy.coordinatePerformingTransition! {
            XCTAssert(context == presentationContext)
            XCTAssert(transitionsHandler === tabBarTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatTabBarTransitionsHandlerForwards_UndoTransitionsAfter_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        tabBarTransitionsHandler.undoTransitionsAfter(transitionId: generatedTansitionId)
        
        // Then
        if case .forContaining(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionsAfter! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === tabBarTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatTabBarTransitionsHandlerForwards_UndoTransitionWith_CallsToItsTransitionsCoordinator() {
        // Given
        let generatedTansitionId = TransitionIdGeneratorImpl().generateNewTransitionId()
        
        // When
        tabBarTransitionsHandler.undoTransitionWith(transitionId: generatedTansitionId)
        
        // Then
        if case .forContaining(let transitionId, let transitionsHandler) = transitionsCoordinatorSpy.coordinateUndoingTransitionWith! {
            XCTAssert(transitionId == generatedTansitionId)
            XCTAssert(transitionsHandler === tabBarTransitionsHandler)
        } else { XCTFail() }
    }
    
    func testThatTabBarTransitionsHandlerDoesNotForward_UndoAllChainedTransitions_CallsToItsTransitionsCoordinator() {
        // When
        tabBarTransitionsHandler.undoAllChainedTransitions()
        
        // Then
        XCTAssertNil(transitionsCoordinatorSpy.coordinateUndoingAllChainedTransitions)
    }
    
    func testThatTabBarTransitionsHandlerDoesNotForward_UndoAllTransitions_CallsToItsTransitionsCoordinator() {
        // When
        tabBarTransitionsHandler.undoAllTransitions()
        
        // Then
        XCTAssertNil(transitionsCoordinatorSpy.coordinateUndoingAllChainedTransitions)
    }

    func testThatTabBarTransitionsHandlerDoesNotForward_ResetWithTransition_CallsToItsTransitionsCoordinator() {
        // Given
        let resettingContext = TransitionContextsCreator.createRegisteringEndpointNavigationControllerTransitionContext()
        
        // When
        tabBarTransitionsHandler.resetWithTransition(context: resettingContext)
        
        // Then
        XCTAssertNil(transitionsCoordinatorSpy.coordinateResettingWithTransition)
    }
    
    // MARK: - TransitionsHandlerContainer
    
    func testThatTabBarTransitionsHandlerReturnsAllTransitionsHandlersOn_AllTransitionsHandlers_Call_IfAllAreAnimating() {
        // Given
        let animatingTransitionsHandler1 = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        let animatingTransitionsHandler2 = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        
        tabBarController.viewControllers = [UIViewController(), UIViewController()]
        tabBarTransitionsHandler.animatingTransitionsHandlers = [
            0: animatingTransitionsHandler1,
            1: animatingTransitionsHandler2
        ]
        
        // When
        let allTransitionsHandlers = tabBarTransitionsHandler.allTransitionsHandlers!
        
        // Then
        XCTAssertNotNil(allTransitionsHandlers.firstIndex { $0 === animatingTransitionsHandler1 })
        XCTAssertNotNil(allTransitionsHandlers.firstIndex { $0 === animatingTransitionsHandler2 })
    }
    
    func testThatTabBarTransitionsHandlerUnboxesContainingTransitionsHandlersAndReturnsAllTransitionsHandlersOn_AllTransitionsHandlers_Call() {
        // Given
        let animatingTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        
        let masterTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        let detailTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        
        let splitViewController = UISplitViewController()
        let splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinatorSpy
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        tabBarController.viewControllers = [splitViewController, UIViewController()]
        tabBarTransitionsHandler.containingTransitionsHandlers = [
            0: splitViewTransitionsHandler
        ]
        tabBarTransitionsHandler.animatingTransitionsHandlers = [
            1: animatingTransitionsHandler
        ]
        
        // When
        let allTransitionsHandlers = tabBarTransitionsHandler.allTransitionsHandlers!
        
        // Then
        XCTAssertNotNil(allTransitionsHandlers.firstIndex { $0 === animatingTransitionsHandler })
        XCTAssertNotNil(allTransitionsHandlers.firstIndex { $0 === masterTransitionsHandler })
        XCTAssertNotNil(allTransitionsHandlers.firstIndex { $0 === detailTransitionsHandler })
    }
    
    func testThatTabBarTransitionsHandlerReturnsVisibleTransitionsHandlerOn_VisibleTransitionsHandlers_Call_IfVisibleIsAnimating() {
        // Given
        let animatingTransitionsHandler1 = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        let animatingTransitionsHandler2 = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        
        tabBarController.viewControllers = [UIViewController(), UIViewController()]
        tabBarTransitionsHandler.animatingTransitionsHandlers = [
            0: animatingTransitionsHandler1,
            1: animatingTransitionsHandler2
        ]
        
        // When
        tabBarController.selectedViewController = tabBarController.viewControllers?[1]
        let visibleTransitionsHandlers = tabBarTransitionsHandler.visibleTransitionsHandlers!
        
        // Then
        XCTAssertNil(visibleTransitionsHandlers.firstIndex { $0 === animatingTransitionsHandler1 })
        XCTAssertNotNil(visibleTransitionsHandlers.firstIndex { $0 === animatingTransitionsHandler2 })
    }
    
    func testThatTabBarTransitionsHandlerUnboxesContainingTransitionsHandlerAndReturnsAllItsTransitionsHandlerOn_VisibleTransitionsHandlers_Call_IfVisibleIsContaining() {
        // Given
        let animatingTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        
        let masterTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        let detailTransitionsHandler = AnimatingTransitionsHandler(transitionsCoordinator: transitionsCoordinatorSpy)
        
        let splitViewController = UISplitViewController()
        let splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinatorSpy
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        tabBarController.viewControllers = [UIViewController(), splitViewController]
        tabBarTransitionsHandler.animatingTransitionsHandlers = [
            0: animatingTransitionsHandler
        ]
        tabBarTransitionsHandler.containingTransitionsHandlers = [
            1: splitViewTransitionsHandler
        ]
        
        // When
        // select a tab with a ContainingTransitionsHandler
        tabBarController.selectedViewController = tabBarController.viewControllers?[1]
        let visibleTransitionsHandlers = tabBarTransitionsHandler.visibleTransitionsHandlers!
        
        // Then
        XCTAssertNil(visibleTransitionsHandlers.firstIndex { $0 === animatingTransitionsHandler })
        XCTAssertNotNil(visibleTransitionsHandlers.firstIndex { $0 === masterTransitionsHandler })
        XCTAssertNotNil(visibleTransitionsHandlers.firstIndex { $0 === detailTransitionsHandler })
    }
}
