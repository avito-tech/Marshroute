import XCTest
@testable import Marshroute

final class DetailRouterTests_BaseMasterDetailRouter: XCTestCase
{
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var targetViewController: UIViewController!
    var nextModuleRouterSeed: RouterSeed!
    
    var router: DetailRouter!
    
    override func setUp() {
        super.setUp()
        
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let peekAndPopTransitionsCoordinator = PeekAndPopUtilityImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: TransitionContextsStackClientProviderImpl(),
            peekAndPopTransitionsCoordinator: peekAndPopTransitionsCoordinator
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
                transitionsHandlersProvider: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl(),
                routerTransitionDelegate: nil
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
        XCTAssertEqual(resettingContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(resettingContext?.targetViewController === targetViewController)
        XCTAssert(resettingContext?.targetTransitionsHandlerBox.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext?.storableParameters)
        if case .some(.resettingNavigationRoot(let launchingContext)) = resettingContext?.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.rootViewController! == targetViewController)
        } else { XCTFail() }
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
        XCTAssertEqual(resettingContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(resettingContext?.targetViewController === targetViewController)
        XCTAssert(resettingContext?.targetTransitionsHandlerBox.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext?.storableParameters)
        if case .some(.resettingNavigationRoot(let launchingContext)) = resettingContext?.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === resetNavigationTransitionsAnimator)
            XCTAssert(launchingContext.rootViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_PushViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // When
        router.pushViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.pendingAnimating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext?.storableParameters)
        if case .some(.push(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! == targetViewController)
        } else { XCTFail() }
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
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.pendingAnimating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext?.storableParameters)
        if case .some(.push(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === navigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
}
