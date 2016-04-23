import XCTest

final class ModalPresentationRouterTests_BaseRouter: XCTestCase
{
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var router: ModalPresentationRouter!
    
    override func setUp() {
        super.setUp()
        
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: TransitionContextsStackClientProviderImpl()
        )
        
        detailAnimatingTransitionsHandlerSpy = AnimatingTransitionsHandlerSpy(
            transitionsCoordinator: transitionsCoordinator
        )
        
        router = BaseRouter(
            routerSeed: RouterSeed(
                transitionsHandlerBox: .init(
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
    
    // MARK: - UIViewController
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(_) = presentationContext.presentationAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
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
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalTransitionsAnimator)
        } else { XCTFail() }
    }
    
    // MARK: - UISplitViewController
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext() {
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
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext.transitionId, nextDetailModuleRouterSeed.transitionId)

        if case .Containing(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(_) = presentationContext.presentationAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        let targetMasterViewController = UIViewController()
        let targetDetailViewController = UIViewController()
        let modalTransitionsAnimator = ModalTransitionsAnimator()
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
            animator: modalTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext.transitionId, nextDetailModuleRouterSeed.transitionId)
        
        if case .Containing(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalTransitionsAnimator)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator_CustomMasterNavigationController_CustomDetailNavigationController_CustomSplitViewController() {
        // Given
        let targetMasterViewController = UIViewController()
        let targetDetailViewController = UIViewController()
        let modalTransitionsAnimator = ModalTransitionsAnimator()
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
            animator: modalTransitionsAnimator,
            masterNavigationController: UINavigationController(),
            detailNavigationController: UINavigationController(),
            splitViewController: UISplitViewController()
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext.transitionId, nextDetailModuleRouterSeed.transitionId)
        
        if case .Containing(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .Modal(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalTransitionsAnimator)
        } else { XCTFail() }
    }
    
    // MARK: - UIViewController in UINavigationController
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalNavigation(_) = presentationContext.presentationAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
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
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalNavigationTransitionsAnimator)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator_CustomNavigationController() {
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let modalNavigationTransitionsAnimator = ModalNavigationTransitionsAnimator()
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
            }, animator: modalNavigationTransitionsAnimator,
               navigationController: UINavigationController()
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalNavigationTransitionsAnimator)
        } else { XCTFail() }
    }
}
