import XCTest
@testable import Marshroute

final class EndpointRouterTests_BaseMasterDetailRouter: XCTestCase
{
    var masterAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var router: EndpointRouter!
    
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
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalEndpointNavigationController_WithCorrectPresentationContext() {
        // Given
        let targetNavigationController = UINavigationController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentModalEndpointNavigationController(targetNavigationController) { (routerSeed) in
            nextModuleRouterSeed = routerSeed
        }
        
        // Then
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetNavigationController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalEndpointNavigation(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.targetNavigationController! == targetNavigationController)
        } else { XCTFail() }
    }
    
    func testThatMasterDetailRouterCallsItsMasterTransitionsHandlerOn_PresentModalEndpointNavigationController_WithCorrectPresentationContext_IfCustomAnimator() {
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
        XCTAssert(masterAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = masterAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext?.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext?.targetViewController === targetNavigationController)
        if case .some(.animating) = presentationContext?.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext?.storableParameters! is NavigationTransitionStorableParameters)
        if case .some(.modalEndpointNavigation(let launchingContext)) = presentationContext?.presentationAnimationLaunchingContextBox {
            XCTAssert(launchingContext.animator === modalEndpointNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetNavigationController! === targetNavigationController)
        } else { XCTFail() }
    }
 
}
