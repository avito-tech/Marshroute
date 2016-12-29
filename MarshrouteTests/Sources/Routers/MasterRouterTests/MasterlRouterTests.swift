import XCTest
@testable import Marshroute

final class MasterlRouterTests: XCTestCase
{
    var masterAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    
    var targetViewController: UIViewController!
    
    var router: MasterRouter!
    
    override func setUp() {
        super.setUp()
        
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: TransitionContextsStackClientProviderImpl()
        )
        
        masterAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        detailAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        targetViewController = UIViewController()
        
        router = BaseMasterDetailRouter(
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterAnimatingTransitionsHandlerSpy
                ),
                detailTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: detailAnimatingTransitionsHandlerSpy
                ),
                transitionId: transitionIdGenerator.generateNewTransitionId(),
                presentingTransitionsHandler: nil,
                transitionsHandlersProvider: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
    }
    
    // MARK: - Master Transitions Handler
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_SetMasterViewControllerDerivedFrom_WithCorrectResettingContext() {
        // Given
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        
        // When
        router.setMasterViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextMasterDetailModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.resetWithTransitionCalled)
        
        let resettingContext = masterAnimatingTransitionsHandlerSpy.resetWithTransitionContextParameter
        XCTAssertEqual(resettingContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssert(resettingContext?.targetViewController === targetViewController)
        XCTAssert(resettingContext?.targetTransitionsHandlerBox.unbox() === masterAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext?.storableParameters)
        if case .some(.resettingNavigationRoot(let launchingContext)) = resettingContext?.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.rootViewController! == targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_SetMasterViewControllerDerivedFrom_WithCorrectResettingContext_IfCustomAnimator() {
        // Given
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        let resetNavigationTransitionsAnimator = ResetNavigationTransitionsAnimator()
        
        // When
        router.setMasterViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextMasterDetailModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: resetNavigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.resetWithTransitionCalled)
        
        let resettingContext = masterAnimatingTransitionsHandlerSpy.resetWithTransitionContextParameter
        XCTAssertEqual(resettingContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssert(resettingContext?.targetViewController === targetViewController)
        XCTAssert(resettingContext?.targetTransitionsHandlerBox.unbox() === masterAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext?.storableParameters)
        if case .some(.resettingNavigationRoot(let launchingContext)) = resettingContext?.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === resetNavigationTransitionsAnimator)
            XCTAssert(launchingContext.rootViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PushMasterViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        
        // When
        router.pushMasterViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextMasterDetailModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.pendingAnimating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext?.storableParameters)
        if case .some(.push(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! == targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PushMasterViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        let navigationTransitionsAnimator = NavigationTransitionsAnimator()
        
        // When
        router.pushMasterViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextMasterDetailModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: navigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.pendingAnimating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext?.storableParameters)
        if case .some(.push(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === navigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    // MARK: - Detail Transitions Handler
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_SetDetailViewControllerDerivedFrom_WithCorrectResettingContext() {
        // Given
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.setDetailViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.resetWithTransitionCalled)
        
        let resettingContext = detailAnimatingTransitionsHandlerSpy.resetWithTransitionContextParameter
        XCTAssertEqual(resettingContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssertEqual(resettingContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(resettingContext?.targetViewController === targetViewController)
        XCTAssert(resettingContext?.targetTransitionsHandlerBox.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext?.storableParameters)
        if case .some(.resettingNavigationRoot(let launchingContext)) = resettingContext?.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.rootViewController! == targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_SetDetailViewControllerDerivedFrom_WithCorrectResettingContext_IfCustomAnimator() {
        // Given
        var nextModuleRouterSeed: RouterSeed!
        let resetNavigationTransitionsAnimator = ResetNavigationTransitionsAnimator()
        
        // When
        router.setDetailViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: resetNavigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.resetWithTransitionCalled)
        
        let resettingContext = detailAnimatingTransitionsHandlerSpy.resetWithTransitionContextParameter
        XCTAssertEqual(resettingContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssertEqual(resettingContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(resettingContext?.targetViewController === targetViewController)
        XCTAssert(resettingContext?.targetTransitionsHandlerBox.unbox() === detailAnimatingTransitionsHandlerSpy)
        XCTAssertNil(resettingContext?.storableParameters)
        if case .some(.resettingNavigationRoot(let launchingContext)) = resettingContext?.resettingAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === resetNavigationTransitionsAnimator)
            XCTAssert(launchingContext.rootViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_PushDetailViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.pushDetailViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.pendingAnimating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssertNil(presentationContext?.storableParameters)
        if case .some(.push(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! == targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsDetailTransitionsHandlerOn_PushDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        var nextModuleRouterSeed: RouterSeed!
        let navigationTransitionsAnimator = NavigationTransitionsAnimator()
        
        // When
        router.pushDetailViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: navigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
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
