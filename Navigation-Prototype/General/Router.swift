import UIKit

protocol Router: class {
    func pushViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func pushViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)

    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)

    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
}

// MARK: - Router Default Impl
extension Router where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionsGeneratorStorer {
    func pushViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            closure,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func pushViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: transitionsHandler)
        
        let pushContext = ForwardTransitionContext(
            pushingViewController: viewController,
            targetTransitionsHandler: transitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandler.performTransition(context: pushContext)
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            masterDeriviationClosure: masterClosure,
            detailDeriviationClosure: detailClosure,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let masterNavigation = UINavigationController()
        let detailNavigation = UINavigationController()
        
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigation, detailNavigation]
        
        let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
        let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
        let splitViewTransitionsHandler = splitViewController.wrappedInSplitViewTransitionsHandler()
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()

        do {
            let masterViewController = masterClosure(
                transitionId: transitionId,
                transitionsHandler: masterTransitionsHandler)
            
            let resetMasterContext = ForwardTransitionContext(
                resetingWithViewController: masterViewController,
                transitionsHandler: masterTransitionsHandler,
                animator: animator,
                transitionId: transitionId)
            
            masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
        }
        
        do {
            let detailViewController = detailClosure(
                transitionId: generatedTransitionId,
                transitionsHandler: detailTransitionsHandler)
            
            let resetDetailContext = ForwardTransitionContext(
                resetingWithViewController: detailViewController,
                transitionsHandler: detailTransitionsHandler,
                animator: animator,
                transitionId: transitionId)
            
            detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalMasterDetailViewController: splitViewController,
            targetTransitionsHandler: splitViewTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

         transitionsHandler.performTransition(context: modalContext)
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            closure,
            animator: NavigationTransitionsAnimator())
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let navigationController = UINavigationController()
        let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        let resetContext = ForwardTransitionContext(
            resetingWithViewController: viewController,
            transitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)
        
        navigationTransitionsHandler.resetWithTransition(context: resetContext)
        
        let modalContext = ForwardTransitionContext(
            presentingModalViewController: viewController,
            inNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandler.performTransition(context: modalContext)
    }
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: closure,
            animator: PopoverTranstionsAnimator(),
            resetAnimator: NavigationTransitionsAnimator()
        )
    }
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
    {
        let navigationController = UINavigationController()
        let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        let resetContext = ForwardTransitionContext(
            resetingWithViewController: viewController,
            transitionsHandler: navigationTransitionsHandler,
            animator: resetAnimator,
            transitionId: generatedTransitionId)
        
        navigationTransitionsHandler.resetWithTransition(context: resetContext)
        
        let popoverController = navigationController.wrappedInPopoverController()
        
        let popoverContext = ForwardTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromRect: rect,
            inView: view,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandler.performTransition(context: popoverContext)
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: closure,
            animator: PopoverTranstionsAnimator(),
            resetAnimator: NavigationTransitionsAnimator()
        )
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
    {
        let navigationController = UINavigationController()
        let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()

        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        let resetContext = ForwardTransitionContext(
            resetingWithViewController: viewController,
            transitionsHandler: navigationTransitionsHandler,
            animator: resetAnimator,
            transitionId: generatedTransitionId)
        
        navigationTransitionsHandler.resetWithTransition(context: resetContext)
        
        let popoverController = navigationController.wrappedInPopoverController()
        
        let popoverContext = ForwardTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandler.performTransition(context: popoverContext)
    }
}