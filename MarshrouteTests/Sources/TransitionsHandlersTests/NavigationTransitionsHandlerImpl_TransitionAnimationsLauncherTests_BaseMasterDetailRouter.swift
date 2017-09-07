import XCTest
@testable import Marshroute

final class NavigationTransitionsHandlerImpl_TransitionAnimationsLauncherTests_BaseMasterDetailRouter: XCTestCase {

    var sourceViewController: UIViewController!
    var targetViewController: UIViewController!
    var masterNavigationController: UINavigationController!
    var detailNavigationController: UINavigationController!
    
    var router: BaseMasterDetailRouter!
    
    override func setUp() {
        super.setUp()
        
        sourceViewController = UIViewController()
        targetViewController = UIViewController()
        
        masterNavigationController = UINavigationController()
        detailNavigationController = UINavigationController()
        
        let transitionIdGenerator = TransitionIdGeneratorImpl()
        let transitionId = transitionIdGenerator.generateNewTransitionId()
        
        let stackClientProvider = TransitionContextsStackClientProviderImpl()
        
        let peekAndPopTransitionsCoordinator = PeekAndPopUtilityImpl()
        
        let transitionsCoordinator = TransitionsCoordinatorImpl(
            stackClientProvider: stackClientProvider,
            peekAndPopTransitionsCoordinator: peekAndPopTransitionsCoordinator
        )
        
        let masterNavigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: masterNavigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let setMasterRootViewControllerContext = ResettingTransitionContext(
            settingRootViewController: sourceViewController,
            forNavigationController: masterNavigationController,
            animatingTransitionsHandler: masterNavigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: transitionId
        )
        
        // set root view controller for a master navigation controller
        masterNavigationTransitionsHandler.resetWithTransition(context: setMasterRootViewControllerContext)
        
        let detailNavigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: detailNavigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let setDetailRootViewControllerContext = ResettingTransitionContext(
            settingRootViewController: sourceViewController,
            forNavigationController: detailNavigationController,
            animatingTransitionsHandler: detailNavigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: transitionId
        )
        
        // set root view controller for a detail navigation controller
        detailNavigationTransitionsHandler.resetWithTransition(context: setDetailRootViewControllerContext)
        
        router = BaseMasterDetailRouter(
            routerSeed: MasterDetailRouterSeed(
                masterTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: masterNavigationTransitionsHandler
                ),
                detailTransitionsHandlerBox: .init(
                    animatingTransitionsHandler: detailNavigationTransitionsHandler
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
    
    // MARK: MasterRouter
    func testThatAnimatorIsCalledWithCorectResettingAnimationContextOn_SetMasterViewControllerDerivedFrom() {
        // Given
        let resetNavigationTransitionsAnimatorSpy = ResetNavigationTransitionsAnimatorSpy()
        
        // When
        router.setMasterViewControllerDerivedFrom( { (_) -> UIViewController in
            return targetViewController
            }, animator: resetNavigationTransitionsAnimatorSpy
        )
        
        // Then
        if case .called(let animationContext) = resetNavigationTransitionsAnimatorSpy.animateResetting! {
            XCTAssert(animationContext.rootViewController === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PushMasterViewControllerDerivedFrom() {
        // Given
        let navigationTransitionsAnimator = NavigationTransitionsAnimatorSpy()
        
        // When
        router.pushMasterViewControllerDerivedFrom( { (_) -> UIViewController in
            return targetViewController
            }, animator: navigationTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = navigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectResettingAnimationContextOn_SetDetailViewControllerDerivedFrom() {
        // Given
        let resetNavigationTransitionsAnimatorSpy = ResetNavigationTransitionsAnimatorSpy()
        
        // When
        router.setDetailViewControllerDerivedFrom( { (_) -> UIViewController in
            return targetViewController
            }, animator: resetNavigationTransitionsAnimatorSpy
        )
        
        // Then
        if case .called(let animationContext) = resetNavigationTransitionsAnimatorSpy.animateResetting! {
            XCTAssert(animationContext.rootViewController === targetViewController)
        } else { XCTFail() }
    }
    
    func testThatAnimatorIsCalledWithCorectPresentationAnimationContextOn_PushDetailViewControllerDerivedFrom() {
        // Given
        let navigationTransitionsAnimator = NavigationTransitionsAnimatorSpy()
        
        // When
        router.pushDetailViewControllerDerivedFrom( { (_) -> UIViewController in
            return targetViewController
            }, animator: navigationTransitionsAnimator
        )
        
        // Then
        if case .called(let animationContext) = navigationTransitionsAnimator.animatePerforming! {
            XCTAssert(animationContext.sourceViewController === sourceViewController)
            XCTAssert(animationContext.targetViewController === targetViewController)
        } else { XCTFail() }
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
        router.presentModalViewControllerDerivedFrom( { (_) -> UIViewController in
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
            deriveMasterViewController: { (_) -> UIViewController in
                return UIViewController()
            },
            deriveDetailViewController: { (_) -> UIViewController in
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
            deriveMasterViewController: { (_) -> UIViewController in
                return UIViewController()
            },
            deriveDetailViewController: { (_) -> UIViewController in
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
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (_) -> UIViewController in
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
        router.presentModalNavigationControllerWithRootViewControllerDerivedFrom( { (_) -> UIViewController in
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
            withViewControllerDerivedFrom: { (_) -> UIViewController in
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
            withViewControllerDerivedFrom: { (_) -> UIViewController in
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
            withViewControllerDerivedFrom: { (_) -> UIViewController in
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
            withViewControllerDerivedFrom: { (_) -> UIViewController in
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
            withViewControllerDerivedFrom: { (_) -> UIViewController in
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
            withViewControllerDerivedFrom: { (_) -> UIViewController in
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
