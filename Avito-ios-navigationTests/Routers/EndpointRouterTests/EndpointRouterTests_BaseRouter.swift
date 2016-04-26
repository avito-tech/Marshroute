import XCTest

final class EndpointRouterTests_BaseRouter: XCTestCase
{
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var router: EndpointRouter!
    
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
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalEndpointNavigationController_WithCorrectPresentationContext() {
        // Given
        let targetNavigationController = UINavigationController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalEndpointNavigationController(targetNavigationController) { (routerSeed) in
            nextModuleRouterSeed = routerSeed
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetNavigationController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalEndpointNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetNavigationController! == targetNavigationController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentModalEndpointNavigationController_WithCorrectPresentationContext_IfCustomAnimator() {
        // Given
        let targetNavigationController = UINavigationController()
        var nextModuleRouterSeed: RouterSeed!
        let modalEndpointNavigationTransitionsAnimator = ModalEndpointNavigationTransitionsAnimator()
        
        // When
        router.presentModalEndpointNavigationController(
            targetNavigationController,
            animator: modalEndpointNavigationTransitionsAnimator) { (routerSeed) in
                nextModuleRouterSeed = routerSeed
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetNavigationController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is NavigationTransitionStorableParameters)
        if case .ModalEndpointNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalEndpointNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetNavigationController! === targetNavigationController)
        } else { XCTFail() }
    }
 
}
