import XCTest

final class AnimatingTransitionsHandlerTransitionAnimationsLauncherTests_BaseRouter: XCTestCase {

    var sourceViewController: UIViewController!
    var targetViewController: UIViewController!
    
    var router: BaseRouter!
    
    override func setUp() {
        super.setUp()
        
        sourceViewController = UIViewController()
        targetViewController = UIViewController()
        
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        
        let stackClientProvider = TransitionContextsStackClientProviderImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: stackClientProvider
        )
        
        let animatingTransitionsHandler = AnimatingTransitionsHandler(
            transitionsCoordinator: transitionsCoordinator
        )
        
        
        let setRootViewControllerContext = ResettingTransitionContext(
            registeringViewController: sourceViewController,
            animatingTransitionsHandler: animatingTransitionsHandler,
            transitionId: transitionIdGenerator.generateNewTransitionId()
        )
        
        // set root view controller for a transitions handler
        animatingTransitionsHandler.resetWithTransition(context: setRootViewControllerContext)
        
        router = BaseRouter(
            routerSeed: RouterSeed(
                transitionsHandlerBox: .init(
                    animatingTransitionsHandler: animatingTransitionsHandler
                ),
                transitionId: transitionIdGenerator.generateNewTransitionId(),
                presentingTransitionsHandler: nil,
                transitionsHandlersProvider: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: RouterControllersProviderImpl()
            )
        )
    }
    
    // MARK: - TransitionAnimationsLauncher
    
    // MARK: DetailRouter
    func testThatAnimatorIsNotCalledOn_SetViewControllerDerivedFrom() {
        // Given
        let resetNavigationTransitionsAnimatorSpy = ResetNavigationTransitionsAnimatorSpy()
        
        // When
        router.setViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            return targetViewController
            }, animator: resetNavigationTransitionsAnimatorSpy
        )
        
        // Then
        XCTAssertNil(resetNavigationTransitionsAnimatorSpy.animateResetting)
    }
    
    func testThatAnimatorIsNotCalledOn_PushViewControllerDerivedFrom() {
        // Given
        let navigationTransitionsAnimator = NavigationTransitionsAnimatorSpy()
        
        // When
        router.pushViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            return targetViewController
            }, animator: navigationTransitionsAnimator
        )
        
        // Then
        XCTAssertNil(navigationTransitionsAnimator.animatePerforming)
    }
    
    // MARK: EndpointRouter
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentModalEndpointNavigationController() {
        // Given
        let targetNavigationController = UINavigationController()
        let modalEndpointNavigationTransitionsAnimator = ModalEndpointNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentModalEndpointNavigationController(
            targetNavigationController,
            animator: modalEndpointNavigationTransitionsAnimator
        ) { _ in }
        
        // Then
        if case .called(let animationContext) = modalEndpointNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetNavigationController === targetNavigationController)
        } else { XCTFail() }
    }
    
    // MARK: ModalPresentationRouter
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentModalViewControllerDerivedFrom() {
        // Given
        let modalTransitionsAnimator = ModalTransitionsAnimatorSpy()
        
        // When
        router.presentModalViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            return targetViewController
            }, animator: modalTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = modalTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentModalMasterDetailViewControllerDerivedFrom() {
        // Given
        let modalMasterDetailTransitionsAnimator = ModalMasterDetailTransitionsAnimatorSpy()
        
        // When
        router.presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: { (routerSeed) -> UIViewController in
                return UIViewController()
            },
            deriveDetailViewController: { (routerSeed) -> UIViewController in
                return UIViewController()
            },
            animator: modalMasterDetailTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = modalMasterDetailTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentModalMasterDetailViewControllerDerivedFrom_IfCustomCustomMasterNavigationController_CustomDetailNavigationController_CustomSplitViewController() {
        // Given
        let modalMasterDetailTransitionsAnimator = ModalMasterDetailTransitionsAnimatorSpy()
        let splitViewController = UISplitViewController()
        
        // When
        router.presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: { (routerSeed) -> UIViewController in
                return UIViewController()
            },
            deriveDetailViewController: { (routerSeed) -> UIViewController in
                return UIViewController()
            },
            animator: modalMasterDetailTransitionsAnimator,
            masterNavigationController: UINavigationController(),
            detailNavigationController: UINavigationController(),
            splitViewController: splitViewController
        )
        
        // Then
        if case .called(let animationContext) = modalMasterDetailTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === splitViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom() {
        // Given
        let modalNavigationTransitionsAnimator = ModalNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            return targetViewController
            }, animator: modalNavigationTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = modalNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentModalNavigationControllerWithRootViewControllerDerivedFrom_IfCustomNavigationController() {
        // Given
        let navigationController = UINavigationController()
        let modalNavigationTransitionsAnimator = ModalNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (routerSeed) -> UIViewController in
            return targetViewController
            }, animator: modalNavigationTransitionsAnimator,
               navigationController: navigationController
        )
        
        // Then
        if case .called(let animationContext) = modalNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            XCTAssert(animationContext.targetNavigationController === navigationController)
        } else { XCTFail() }
    }
    
    // MARK: PopoverPresentationRouter
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentPopoverFromRect() {
        guard UIDevice.current.userInterfaceIdiom == .pad
            else { return }
        
        // Given
        let rect = CGRect(x: 0, y: 1, width: 2, height: 3)
        let view = UIView()
        let popoverTransitionsAnimator = PopoverTransitionsAnimatorSpy()
        
        // When
        router.presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                return targetViewController
            },
            animator: popoverTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = popoverTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            if case .popoverFromView(let sourceView, let sourceRect) = animationContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentPopoverFromBarButtonItem() {
        guard UIDevice.current.userInterfaceIdiom == .pad
            else { return }
        
        // Given
        let barButtonItem = UIBarButtonItem()
        let popoverTransitionsAnimator = PopoverTransitionsAnimatorSpy()
        
        // When
        router.presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                return targetViewController
            },
            animator: popoverTransitionsAnimator
            )
        
        // Then
        if case .called(let animationContext) = popoverTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            if case .popoverFromBarButtonItem(let buttonItem) = animationContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentPopoverWithNavigationControllerFromRect() {
        guard UIDevice.current.userInterfaceIdiom == .pad
            else { return }
        
        // Given
        let rect = CGRect(x: 0, y: 1, width: 2, height: 3)
        let view = UIView()
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = popoverNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            if case .popoverFromView(let sourceView, let sourceRect) = animationContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentPopoverWithNavigationControllerFromRect_IfCustomNavigationController() {
        guard UIDevice.current.userInterfaceIdiom == .pad
            else { return }
        
        // Given
        let rect = CGRect(x: 0, y: 1, width: 2, height: 3)
        let view = UIView()
        let navigationController = UINavigationController()
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator,
            navigationController: navigationController
        )
        
        // Then
        if case .called(let animationContext) = popoverNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            XCTAssert(animationContext.targetNavigationController === navigationController)
            if case .popoverFromView(let sourceView, let sourceRect) = animationContext.transitionStyle {
                XCTAssertEqual(sourceRect, rect)
                XCTAssertEqual(sourceView, view)
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentPopoverWithNavigationControllerFromBarButtonItem() {
        guard UIDevice.current.userInterfaceIdiom == .pad
            else { return }
        
        // Given
        let barButtonItem = UIBarButtonItem()
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = popoverNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            if case .popoverFromBarButtonItem(let buttonItem) = animationContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PresentPopoverWithNavigationControllerFromBarButtonItem_IfCustomnavigationController() {
        guard UIDevice.current.userInterfaceIdiom == .pad
            else { return }
        
        // Given
        let barButtonItem = UIBarButtonItem()
        let navigationController = UINavigationController()
        let popoverNavigationTransitionsAnimator = PopoverNavigationTransitionsAnimatorSpy()
        
        // When
        router.presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: { (routerSeed) -> UIViewController in
                return targetViewController
            },
            animator: popoverNavigationTransitionsAnimator,
            navigationController: navigationController
        )
        
        // Then
        if case .called(let animationContext) = popoverNavigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
            XCTAssert(animationContext.targetNavigationController === navigationController)
            if case .popoverFromBarButtonItem(let buttonItem) = animationContext.transitionStyle {
                XCTAssert(buttonItem === barButtonItem)
            } else { XCTFail() }
        } else { XCTFail() }
    }
}
