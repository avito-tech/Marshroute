import XCTest

final class ModalPresentationRouterTests_BaseMasterDetailRouter: XCTestCase
{
    var masterAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var router: ModalPresentationRouter!
    
    override func setUp() {
        super.setUp()
        
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: TransitionContextsStackClientProviderImpl()
        )
        
        masterAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        router = BaseMasterDetailRouter(
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterAnimatingTransitionsHandlerSpy
                ),
                detailTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: AnimatingTransitionsHandlerSpy(
                        transitionsCoordinator: transitionsCoordinator
                    )
                ),
                transitionId: transitionIdGenerator.generateNewTransitionId(),
                presentingTransitionsHandler: nil,
                transitionsHandlersProvider: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
    }
    
    // MARK: - UIViewController
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! == targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let modalTransitionsAnimator = ModalTransitionsAnimator()
        
        // When
        router.presentModalViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: modalTransitionsAnimator
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    // MARK: - UISplitViewController
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        let targetMasterViewController = UIViewController()
        let targetDetailViewController = UIViewController()
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        var nextDetailModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: { (routerSeed) -> UIViewController in
                nextMasterDetailModuleRouterSeed = routerSeed
                return targetMasterViewController
            },
            deriveDetailViewController: { (routerSeed) -> UIViewController in
                nextDetailModuleRouterSeed = routerSeed
                return targetDetailViewController
            }
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext.transitionId, nextDetailModuleRouterSeed.transitionId)

        if case .Containing(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalMasterDetail(_) = presentationContext.presentationAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        let targetMasterViewController = UIViewController()
        let targetDetailViewController = UIViewController()
        let modalMasterDetailTransitionsAnimator = ModalMasterDetailTransitionsAnimator()
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        var nextDetailModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: { (routerSeed) -> UIViewController in
                nextMasterDetailModuleRouterSeed = routerSeed
                return targetMasterViewController
            },
            deriveDetailViewController: { (routerSeed) -> UIViewController in
                nextDetailModuleRouterSeed = routerSeed
                return targetDetailViewController
            },
            animator: modalMasterDetailTransitionsAnimator
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext.transitionId, nextDetailModuleRouterSeed.transitionId)
        
        if case .Containing(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalMasterDetail(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalMasterDetailTransitionsAnimator)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator_CustomMasterNavigationController_CustomDetailNavigationController_CustomSplitViewController() {
        // Given
        let targetMasterViewController = UIViewController()
        let targetDetailViewController = UIViewController()
        let splitViewController = UISplitViewController()
        let modalMasterDetailTransitionsAnimator = ModalMasterDetailTransitionsAnimator()
        var nextMasterDetailModuleRouterSeed: MasterDetailRouterSeed!
        var nextDetailModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: { (routerSeed) -> UIViewController in
                nextMasterDetailModuleRouterSeed = routerSeed
                return targetMasterViewController
            },
            deriveDetailViewController: { (routerSeed) -> UIViewController in
                nextDetailModuleRouterSeed = routerSeed
                return targetDetailViewController
            },
            animator: modalMasterDetailTransitionsAnimator,
            masterNavigationController: UINavigationController(),
            detailNavigationController: UINavigationController(),
            splitViewController: splitViewController
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext.transitionId, nextDetailModuleRouterSeed.transitionId)
        
        if case .Containing(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalMasterDetail(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalMasterDetailTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === splitViewController)
        } else { XCTFail() }
    }
    
    // MARK: - UIViewController in UINavigationController
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let modalNavigationTransitionsAnimator = ModalNavigationTransitionsAnimator()
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: modalNavigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator_CustomNavigationController() {
        // Given
        let targetViewController = UIViewController()
        let navigationController = UINavigationController()
        var nextModuleRouterSeed: RouterSeed!
        let modalNavigationTransitionsAnimator = ModalNavigationTransitionsAnimator()
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: modalNavigationTransitionsAnimator,
               navigationController: navigationController
        )
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
            XCTAssert(launchingContext.targetNavigationController! === navigationController)
        } else { XCTFail() }
    }
}
