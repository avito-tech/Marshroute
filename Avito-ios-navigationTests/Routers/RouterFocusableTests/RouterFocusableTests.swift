import XCTest

final class RouterFocusableTests: XCTestCase
{
    var transitionId: TransitionId!
    var transitionIdGenerator: TransitionIdGenerator!
    var transitionsCoordinator: TransitionsCoordinator!
    
    var masterAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var masterContainingTransitionsHandlerSpy: ContainingTransitionsHandlerSpy!
    var detailContainingTransitionsHandlerSpy: ContainingTransitionsHandlerSpy!
    
    override func setUp() {
        super.setUp()
        
        transitionIdGenerator = TransitionIdGeneratorImpl()
        transitionId = transitionIdGenerator.generateNewTransitionId()
        
        transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: TransitionContextsStackClientProviderImpl()
        )
        
        masterAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        detailAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        masterContainingTransitionsHandlerSpy = ContainingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        detailContainingTransitionsHandlerSpy = ContainingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
    }

    // MARK: - BaseRouter
    
    func testThatNotRootRouterCallsItsTransitionsHandlerOn_FocusOnCurrentModule_IfItsTransitionHandlerIsAnimating() {
        // Given
        let router = BaseRouter( // Base Router
            routerSeed: RouterSeed(
                transitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterAnimatingTransitionsHandlerSpy // Animating Transitions Handler
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: masterContainingTransitionsHandlerSpy, // Not Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        router.focusOnCurrentModule()
        
        // Then 
        XCTAssert(router.transitionsHandlerBox?.unbox() === masterAnimatingTransitionsHandlerSpy)
        XCTAssert(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertEqual(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterTransitionIdParameter, transitionId)
    }
    
    func testThatNotRootRouterCallsItsTransitionsHandlerOn_FocusOnCurrentModule_IfItsTransitionHandlerIsContaining() {
        // Given
        let router = BaseRouter( // Base Router
            routerSeed: RouterSeed(
                transitionsHandlerBox: .init(
                    containingTransitionsHandler: masterContainingTransitionsHandlerSpy // Containing Transitions Handler
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: masterContainingTransitionsHandlerSpy, // Not Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        router.focusOnCurrentModule()
        
        // Then
        XCTAssert(router.transitionsHandlerBox?.unbox() === masterContainingTransitionsHandlerSpy)
        XCTAssert(masterContainingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertEqual(masterContainingTransitionsHandlerSpy.undoTransitionsAfterTransitionIdParameter, transitionId)
    }
    
    func testThatRootRouterCallsItsTransitionsHandlerOn_FocusOnCurrentModule_IfItsTransitionHandlerIsAnimating() {
        // Given
        let router = BaseRouter( // Router
            routerSeed: RouterSeed(
                transitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterAnimatingTransitionsHandlerSpy  // Animating Transitions Handler
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: nil, // Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        router.focusOnCurrentModule()
        
        // Then
        XCTAssert(router.transitionsHandlerBox?.unbox() === masterAnimatingTransitionsHandlerSpy)
        XCTAssert(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertEqual(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterTransitionIdParameter, transitionId)
    }
    
    func testThatRootRouterDoesNotCallItsTransitionsHandlerOn_FocusOnCurrentModule_IfItsTransitionHandlerIsContaining() {
        // Given
        let router = BaseRouter( // Router
            routerSeed: RouterSeed(
                transitionsHandlerBox: .init(
                    containingTransitionsHandler: masterContainingTransitionsHandlerSpy // Containing Transitions Handler
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: nil, // Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        router.focusOnCurrentModule()
        
        // Then
        XCTAssert(router.transitionsHandlerBox?.unbox() === masterContainingTransitionsHandlerSpy)
        XCTAssertFalse(masterContainingTransitionsHandlerSpy.undoTransitionsAfterCalled)
    }
    
    // MARK: - BaseMasterDetailRouter
    
    func testThatNotRootMasterDetailRouterCallsItsMasterTransitionsHandlerOn_FocusOnCurrentModule_IfItsMasterTransitionHandlerIsAnimating() {
        // Given
        let masterDetailRouter = BaseMasterDetailRouter( // MasterDetail Router
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterAnimatingTransitionsHandlerSpy // Animating Master Transitions Handler
                ),
                detailTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: detailAnimatingTransitionsHandlerSpy
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: masterAnimatingTransitionsHandlerSpy, // Not Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        masterDetailRouter.focusOnCurrentModule()
        
        // Then
        XCTAssert(masterDetailRouter.masterTransitionsHandlerBox?.unbox() === masterAnimatingTransitionsHandlerSpy)
        XCTAssert(masterDetailRouter.detailTransitionsHandlerBox?.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssert(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertEqual(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterTransitionIdParameter, transitionId)
        XCTAssertFalse(detailAnimatingTransitionsHandlerSpy.undoTransitionsAfterCalled)
    }
    
    func testThatNotRootMasterDetailRouterCallsItsMasterTransitionsHandlerOn_FocusOnCurrentModule_IfItsMasterTransitionHandlerIsContaining() {
        // Given
        let masterDetailRouter = BaseMasterDetailRouter( // MasterDetail Router
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    containingTransitionsHandler: masterContainingTransitionsHandlerSpy // Containing Master Transitions Handler
                ),
                detailTransitionsHandlerBox: .init(
                    containingTransitionsHandler: detailContainingTransitionsHandlerSpy
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: masterAnimatingTransitionsHandlerSpy, // Not Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        masterDetailRouter.focusOnCurrentModule()
        
        // Then
        XCTAssert(masterDetailRouter.masterTransitionsHandlerBox?.unbox() === masterContainingTransitionsHandlerSpy)
        XCTAssert(masterDetailRouter.detailTransitionsHandlerBox?.unbox() === detailContainingTransitionsHandlerSpy)
        XCTAssert(masterContainingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertEqual(masterContainingTransitionsHandlerSpy.undoTransitionsAfterTransitionIdParameter, transitionId)
        XCTAssertFalse(detailContainingTransitionsHandlerSpy.undoTransitionsAfterCalled)
    }
    
    func testThatRootMasterDetailRouterCallsItsMasterTransitionsHandlerOn_FocusOnCurrentModule_IfItsMasterTransitionHandlerIsAnimating() {
        // Given
        let masterDetailRouter = BaseMasterDetailRouter( // MasterDetail Router
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterAnimatingTransitionsHandlerSpy // Animating Master Transitions Handler
                ),
                detailTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: detailAnimatingTransitionsHandlerSpy
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: nil, // Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        masterDetailRouter.focusOnCurrentModule()
        
        // Then
        XCTAssert(masterDetailRouter.masterTransitionsHandlerBox?.unbox() === masterAnimatingTransitionsHandlerSpy)
        XCTAssert(masterDetailRouter.detailTransitionsHandlerBox?.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssert(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertEqual(masterAnimatingTransitionsHandlerSpy.undoTransitionsAfterTransitionIdParameter, transitionId)
        XCTAssertFalse(detailAnimatingTransitionsHandlerSpy.undoTransitionsAfterCalled)
    }
    
    func testThatRootMasterDetailRouterDoesNotCallItsMasterTransitionsHandlerOn_FocusOnCurrentModule_IfItsMasterTransitionHandlerIsContaining() {
        // Given
        let masterDetailRouter = BaseMasterDetailRouter( // MasterDetail Router
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    containingTransitionsHandler: masterContainingTransitionsHandlerSpy // Containing Master Transitions Handler
                ),
                detailTransitionsHandlerBox: .init(
                    containingTransitionsHandler: detailContainingTransitionsHandlerSpy
                ),
                transitionId: transitionId,
                presentingTransitionsHandler: nil, // Root Router
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
        
        // When
        masterDetailRouter.focusOnCurrentModule()
        
        // Then
        XCTAssert(masterDetailRouter.masterTransitionsHandlerBox?.unbox() === masterContainingTransitionsHandlerSpy)
        XCTAssert(masterDetailRouter.detailTransitionsHandlerBox?.unbox() === detailContainingTransitionsHandlerSpy)
        XCTAssertFalse(masterContainingTransitionsHandlerSpy.undoTransitionsAfterCalled)
        XCTAssertFalse(detailContainingTransitionsHandlerSpy.undoTransitionsAfterCalled)
    }
}
