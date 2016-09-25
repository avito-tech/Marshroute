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
                transitionsHandlersProvider: transitionsCoordinator,
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
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modal(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! == targetViewController)
        } else { XCTFail() }
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
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modal(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
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
        XCTAssertEqual(presentationContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext?.transitionId, nextDetailModuleRouterSeed.transitionId)

        if case .some(.containing) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalMasterDetail) = presentationContext?.presentationAnimationLaunchingContextBox {} else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator() {
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
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext?.transitionId, nextDetailModuleRouterSeed.transitionId)
        
        if case .some(.containing) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalMasterDetail(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalMasterDetailTransitionsAnimator)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalMasterDetailViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator_CustomMasterNavigationController_CustomDetailNavigationController_CustomSplitViewController() {
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
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextMasterDetailModuleRouterSeed.transitionId)
        XCTAssertEqual(presentationContext?.transitionId, nextDetailModuleRouterSeed.transitionId)
        
        if case .some(.containing) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalMasterDetail(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalMasterDetailTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === splitViewController)
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
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalNavigation(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetViewController! == targetViewController)
        } else { XCTFail() }
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
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalNavigation(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_WithCorrectPresentationContext_IfCustomAnimator_CustomNavigationController() {
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
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetViewController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalNavigation(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
            XCTAssert(launchingContext.targetNavigationController! === navigationController)
        } else { XCTFail() }
    }
}
