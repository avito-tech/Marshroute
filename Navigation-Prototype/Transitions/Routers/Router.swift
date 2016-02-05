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
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)

    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    
    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        navigationController: UINavigationController)

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
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - Router Default Impl
extension Router where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionsGeneratorStorer, Self: TransitionsCoordinatorStorer {
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
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
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
        presentModalMasterDetailViewControllerDerivedFrom(
            masterDeriviationClosure: masterClosure,
            detailDeriviationClosure: detailClosure,
            animator: animator,
            masterNavigationController: UINavigationController(),
            detailNavigationController: UINavigationController(),
            splitViewController: UISplitViewController()
        )
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let masterTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: masterNavigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let detailTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: detailNavigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinator)
        
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
            animator: NavigationTransitionsAnimator()
        )
    }

    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        presentModalViewControllerDerivedFrom(
            closure,
            animator: animator,
            navigationController: UINavigationController()
        )
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        do {
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: navigationTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId)
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
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
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: closure,
            animator: animator,
            resetAnimator: resetAnimator,
            navigationController: UINavigationController()
        )
    }
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        do {
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: navigationTransitionsHandler,
                animator: resetAnimator,
                transitionId: generatedTransitionId)
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
        
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
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: closure,
            animator: animator,
            resetAnimator: resetAnimator,
            navigationController: UINavigationController()
        )
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)

        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = closure(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        do {
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: navigationTransitionsHandler,
                animator: resetAnimator,
                transitionId: generatedTransitionId)
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
    
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