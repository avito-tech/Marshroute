import UIKit

/// Роутер, показывающий UIPopoverController с UIViewController'ом, обернутым или необернутым в UINavigationController
public protocol PopoverPresentationRouter: class {
    // MARK: - UIViewController in UIPopoverController
    func presentPopoverFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    func presentPopoverWithNavigationControllerFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverWithNavigationControllerFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    
    func presentPopoverWithNavigationControllerFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverWithNavigationControllerFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverWithNavigationControllerFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator)
    
    func presentPopoverWithNavigationControllerFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - PopoverPresentationRouter Default Impl
extension PopoverPresentationRouter where
    Self: RouterTransitionable,
    Self: RouterIdentifiable,
    Self: TransitionIdGeneratorHolder,
    Self: TransitionsHandlersProviderHolder,
    Self: RouterControllersProviderHolder
{
    // MARK: - UIViewController in UIPopoverController
    public func presentPopoverFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    {
        let animatingTransitionsHandler = transitionsHandlersProvider.animatingTransitionsHandler()
        
        let animatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let presentingTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: transitionsHandlerBox
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: animatingTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: presentingTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed)
        
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
        
        presentingTransitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    public func presentPopoverFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator)
    {
        let animatingTransitionsHandler = transitionsHandlersProvider.animatingTransitionsHandler()
        
        let animatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let presentingTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: transitionsHandlerBox
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: animatingTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: presentingTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed)
        
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
        
        presentingTransitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    // MARK: - UIViewController in UINavigationController in UIPopoverController
    public func presentPopoverWithNavigationControllerFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverWithNavigationControllerFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverNavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverWithNavigationControllerFromRect(
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
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
        _ rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        let navigationTransitionsHandler = transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
        let presentingTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: transitionsHandlerBox
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: presentingTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed)
        
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

        presentingTransitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    public func presentPopoverWithNavigationControllerFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverWithNavigationControllerFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverNavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverWithNavigationControllerFromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
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
        _ barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        let navigationTransitionsHandler = transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )

        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
        let presentingTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: transitionsHandlerBox
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: presentingTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed)

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

        presentingTransitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
}
