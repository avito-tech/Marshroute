import XCTest

final class DetailRouterTests_BaseMasterDetailRouter: XCTestCase
{
    var transitionIdGenerator: TransitionIdGenerator!
    var transitionsCoordinator: TransitionsCoordinator!
    
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var targetViewController: UIViewController!
    var nextModuleRouterSeed: RouterSeed!
    
    var router: DetailRouter!
    
    override func setUp() {
        super.setUp()
        
        transitionIdGenerator = TransitionIdGeneratorImpl()
        
        transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: TransitionContextsStackClientProviderImpl()
        )
        
        detailAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        targetViewController = UIViewController()
        
        router = BaseMasterDetailRouter(
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: AnimatingTransitionsHandlerSpy(
                        transitionsCoordinator: transitionsCoordinator
                    )
                ),
                detailTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: detailAnimatingTransitionsHandlerSpy
                ),
                transitionId: transitionIdGenerator.generateNewTransitionId(),
                presentingTransitionsHandler: nil,
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_SetViewControllerDerivedFrom_WithCorrectResettingContext() {
        // When
        router.setViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.resetWithTransitionCalled)
        
        let resettingContext = detailAnimatingTransitionsHandlerSpy.resetWithTransitionContextParameter
        XCTAssertEqual(resettingContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(resettingContext.targetViewController === targetViewController)
        XCTAssert(resettingContext.targetTransitionsHandlerBox.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext.storableParameters)
        if case .ResettingNavigationRoot(_) = resettingContext.resettingAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_SetViewControllerDerivedFrom_WithCorrectResettingContext_IfCustomAnimator() {
        // Given
        let resetNavigationTransitionsAnimator = ResetNavigationTransitionsAnimator()
        
        // When
        router.setViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: resetNavigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.resetWithTransitionCalled)
        
        let resettingContext = detailAnimatingTransitionsHandlerSpy.resetWithTransitionContextParameter
        XCTAssertEqual(resettingContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(resettingContext.targetViewController === targetViewController)
        XCTAssert(resettingContext.targetTransitionsHandlerBox.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext.storableParameters)
        if case .ResettingNavigationRoot(let launchingContext) = resettingContext.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === resetNavigationTransitionsAnimator)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_PushViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // When
        router.pushViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .PendingAnimating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext.storableParameters)
        if case .Push(_) = presentationContext.presentationAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_PushViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        let navigationTransitionsAnimator = NavigationTransitionsAnimator()
        
        // When
        router.pushViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: navigationTransitionsAnimator
        )
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .PendingAnimating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext.storableParameters)
        if case .Push(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === navigationTransitionsAnimator)
        } else { XCTFail() }
    }
}
