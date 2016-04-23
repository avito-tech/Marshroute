import UIKit

public protocol PopoverPresentationRouter: class {
    // MARK: - UIViewController in UIPopoverController
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    func presentPopoverWithNavigationControllerFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverWithNavigationControllerFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    
    func presentPopoverWithNavigationControllerFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverWithNavigationControllerFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverWithNavigationControllerFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    
    func presentPopoverWithNavigationControllerFromBarButtonItem(
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
    // MARK: - UIViewController in UIPopoverController
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let animatingTransitionsHandler = AnimatingTransitionsHandler(
            transitionsCoordinator: transitionsCoordinator
        )
        
        let animatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: animatingTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ResettingTransitionContext(
                registeringViewController: viewController,
                animatingTransitionsHandler: animatingTransitionsHandler,
                transitionId: generatedTransitionId
            )
            
            animatingTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: viewController)
        
        let popoverContext = PresentationTransitionContext(
            presentingViewController: viewController,
            inPopoverController: popoverController,
            fromRect: rect,
            inView: view,
            targetTransitionsHandler: animatingTransitionsHandler,
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
            animator: PopoverTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let animatingTransitionsHandler = AnimatingTransitionsHandler(
            transitionsCoordinator: transitionsCoordinator)
        
        let animatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: animatingTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ResettingTransitionContext(
                registeringViewController: viewController,
                animatingTransitionsHandler: animatingTransitionsHandler,
                transitionId: generatedTransitionId
            )
            
            animatingTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: viewController)
        
        let popoverContext = PresentationTransitionContext(
            presentingViewController: viewController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem,
            targetTransitionsHandler: animatingTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    public func presentPopoverWithNavigationControllerFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverNavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverWithNavigationControllerFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    {
        presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentPopoverWithNavigationControllerFromRect(
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
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
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
    
    public func presentPopoverWithNavigationControllerFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverNavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverWithNavigationControllerFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    {
        presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentPopoverWithNavigationControllerFromBarButtonItem(
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

        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
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