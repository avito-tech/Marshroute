import UIKit

public protocol PopoverPresentationRouter: class {
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - PopoverPresentationRouter Default Impl
extension PopoverPresentationRouter where
    Self: RouterTransitionable,
    Self: RouterIdentifiable,
    Self: TransitionIdGeneratorHolder,
    Self: TransitionsCoordinatorHolder,
    Self: RouterControllersProviderHolder
{
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverNavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: navigationTransitionsHandler)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ResettingTransitionContext(
                settingRootViewController: viewController,
                forNavigationController: navigationController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: generatedTransitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
        
        let popoverContext = PresentationTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromRect: rect,
            inView: view,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )

        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverNavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)

        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: navigationTransitionsHandler)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)

        do {
            let resetContext = ResettingTransitionContext(
                settingRootViewController: viewController,
                forNavigationController: navigationController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: generatedTransitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
    
        let popoverContext = PresentationTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )

        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
}