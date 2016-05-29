import XCTest

final class PopoverPresentationRouterTests_BaseRouter: XCTestCase
{
    var detailAnimatingTransitionsHandlerSpy: AnimatingTransitionsHandlerSpy!
    var router: PopoverPresentationRouter!
    
    let rect = CGRect(x: 0, y: 1, width: 2, height: 3)
    let view = UIView()
    let barButtonItem = UIBarButtonItem()
    
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

    // MARK: - UIViewController in UIPopoverController
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverFromRect_WithCorrectPresentationContext() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentPopoverFromRect(rect, inView: view) { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .Popover(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromView(let sourceView, let sourceRect) = launchingContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentPopoverFromRect_WithCorrectPresentationContext_IfCustomAnimator() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let popoverTransitionsAnimator = PopoverTransitionsAnimator()
        
        // When
        router.presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                nextModuleRouterSeed = routerSeed
                return targetViewController
            },
            animator: popoverTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .Popover(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromView(let sourceView, let sourceRect) = launchingContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
            XCTAssert(launchingContext.animator === popoverTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverFromBarButtonItem_WithCorrectPresentationContext() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentPopoverFromBarButtonItem(barButtonItem) { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .Popover(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromBarButtonItem(let buttonItem) = launchingContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverFromBarButtonItem_WithCorrectPresentationContext_IfCustomAnimator() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let popoverTransitionsAnimator = PopoverTransitionsAnimator()
        
        // When
        router.presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                nextModuleRouterSeed = routerSeed
                return targetViewController
            },
            animator: popoverTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .Popover(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromBarButtonItem(let buttonItem) = launchingContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
            XCTAssert(launchingContext.animator === popoverTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverWithNavigationControllerFromRect_WithCorrectPresentationContext() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentPopoverWithNavigationControllerFromRect(rect, inView: view) { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .PopoverNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromView(let sourceView, let sourceRect) = launchingContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentPopoverWithNavigationControllerFromRect_WithCorrectPresentationContext_IfCustomAnimator() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimator()
        
        // When
        router.presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                nextModuleRouterSeed = routerSeed
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .PopoverNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromView(let sourceView, let sourceRect) = launchingContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
            XCTAssert(launchingContext.animator === popoverNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_PresentPopoverWithNavigationControllerFromRect_WithCorrectPresentationContext_IfCustomAnimator_CustomNavigationController() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        let navigationController = UINavigationController()
        var nextModuleRouterSeed: RouterSeed!
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimator()
        
        // When
        router.presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                nextModuleRouterSeed = routerSeed
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator,
            navigationController: navigationController
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .PopoverNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromView(let sourceView, let sourceRect) = launchingContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
            XCTAssert(launchingContext.animator === popoverNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
            XCTAssert(launchingContext.targetNavigationController! === navigationController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverWithNavigationControllerFromBarButtonItem_WithCorrectPresentationContext() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        
        // When
        router.presentPopoverWithNavigationControllerFromBarButtonItem(barButtonItem) { (routerSeed) -> UIViewController in
            nextModuleRouterSeed = routerSeed
            return targetViewController
        }
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating(_) = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .PopoverNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromBarButtonItem(let buttonItem) = launchingContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverWithNavigationControllerFromBarButtonItem_WithCorrectPresentationContext_IfCustomAnimator() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        var nextModuleRouterSeed: RouterSeed!
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimator()
        
        // When
        router.presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                nextModuleRouterSeed = routerSeed
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .PopoverNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromBarButtonItem(let buttonItem) = launchingContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
            XCTAssert(launchingContext.animator === popoverNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatRouterCallsItsTransitionsHandlerOn_presentPopoverWithNavigationControllerFromBarButtonItem_WithCorrectPresentationContext_IfCustomAnimator_CustomNavigationController() {
        guard UIDevice.currentDevice().userInterfaceIdiom == .Pad
            else { return }
        
        // Given
        let targetViewController = UIViewController()
        let navigationController = UINavigationController()
        var nextModuleRouterSeed: RouterSeed!
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimator()
        
        // When
        router.presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                nextModuleRouterSeed = routerSeed
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator,
            navigationController: navigationController
        )
        
        // Then
        XCTAssert(detailAnimatingTransitionsHandlerSpy.performTransitionCalled)
        
        let presentationContext = detailAnimatingTransitionsHandlerSpy.perFormTransitionContextParameter
        XCTAssertEqual(presentationContext.transitionId, nextModuleRouterSeed.transitionId)
        XCTAssert(presentationContext.targetViewController === targetViewController)
        if case .Animating = presentationContext.targetTransitionsHandlerBox {} else { XCTFail() }
        XCTAssert(presentationContext.storableParameters! is PopoverTransitionStorableParameters)
        if case .PopoverNavigation(let launchingContext) = presentationContext.presentationAnimationLaunchingContextBox {
            if case .PopoverFromBarButtonItem(let buttonItem) = launchingContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
            XCTAssert(launchingContext.animator === popoverNavigationTransitionsAnimator)
            XCTAssert(launchingContext.targetViewController! === targetViewController)
            XCTAssert(launchingContext.targetNavigationController! === navigationController)
        } else { XCTFail() }
    }
}
