import UIKit

class BaseRouter: Router {
    // TransitionsHandlerStorer
    var transitionsHandler: TransitionsHandler
    
    // RouterDismisable
    weak var parentTransitionsHandler: TransitionsHandler?
    var transitionId: TransitionId?
    
    init(transitionsHandler: TransitionsHandler, transitionId: TransitionId?, parentTransitionsHandler: TransitionsHandler?) {
        self.transitionId = transitionId
        self.transitionsHandler = transitionsHandler
        self.parentTransitionsHandler = parentTransitionsHandler
    }
}

// MARK: - helpers
extension BaseRouter {
    final func setMasterViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            closure, animator: NavigationTransitionsAnimator()
        )
    }
    
    final func setMasterViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        self.transitionsHandler.resetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let viewController = closure(
                transitionId: generatedTransitionId,
                transitionsHandler: self.transitionsHandler)
            
            let resetMasterContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: self.transitionsHandler,
                animator: animator)
            
            return resetMasterContext
        }
    }
    
    final func pushViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            closure,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    final func pushViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        transitionsHandler.performTransition(contextCreationClosure: { (generatedTransitionId: TransitionId) -> ForwardTransitionContext in
            let viewController = closure(
                transitionId: generatedTransitionId,
                transitionsHandler: self.transitionsHandler)
            
            let pushContext = ForwardTransitionContext(
                pushingViewController: viewController,
                targetTransitionsHandler: self.transitionsHandler,
                animator: animator)
            
            return pushContext
        })
    }
    
    final func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            masterDeriviationClosure: masterClosure,
            detailDeriviationClosure: detailClosure,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    final func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        transitionsHandler.performTransition { (generatedTransitionId: TransitionId) -> ForwardTransitionContext in
            let masterNavigation = UINavigationController()
            let detailNavigation = UINavigationController()
            
            let splitViewController = UISplitViewController()
            splitViewController.viewControllers = [masterNavigation, detailNavigation]
            
            let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
            let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
            let splitViewTransitionsHandler = splitViewController.wrappedInSplitViewTransitionsHandler()
            
            splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
            splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
            
            masterTransitionsHandler.resetWithTransition(contextCreationClosure: { (generatedTransitionId) -> ForwardTransitionContext in
                let masterViewController = masterClosure(
                    transitionId: generatedTransitionId,
                    transitionsHandler: masterTransitionsHandler)
                
                let resetMasterContext = ForwardTransitionContext(
                    resetingWithViewController: masterViewController,
                    transitionsHandler: masterTransitionsHandler,
                    animator: animator)
                
                return resetMasterContext
            })
            
            detailTransitionsHandler.resetWithTransition(contextCreationClosure: { (generatedTransitionId) -> ForwardTransitionContext in
                let detailViewController = detailClosure(
                    transitionId: generatedTransitionId,
                    transitionsHandler: detailTransitionsHandler)
                
                let resetDetailContext = ForwardTransitionContext(
                    resetingWithViewController: detailViewController,
                    transitionsHandler: detailTransitionsHandler,
                    animator: animator)
                
                return resetDetailContext
            })
            
            let modalContext = ForwardTransitionContext(
                presentingModalMasterDetailViewController: splitViewController,
                targetTransitionsHandler: splitViewTransitionsHandler,
                animator: animator)
            
            return modalContext
        }
    }
    
    final func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            closure,
            animator: NavigationTransitionsAnimator())
    }
    
    final func presentModalViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        transitionsHandler.performTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let navigationController = UINavigationController()
            let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
            
            // приходится делать optional, иначе `variable captured by a closure before being initialized`
            var modalViewController: UIViewController? = nil
            
            navigationTransitionsHandler.resetWithTransition(contextCreationClosure: { (generatedTransitionId) -> ForwardTransitionContext in
                let viewController = closure(
                    transitionId: generatedTransitionId,
                    transitionsHandler: navigationTransitionsHandler)
                
                let resetContext = ForwardTransitionContext(
                    resetingWithViewController: viewController,
                    transitionsHandler: navigationTransitionsHandler,
                    animator: animator)
                
                modalViewController = viewController
                
                return resetContext
            })
            
            assert(modalViewController != nil)
            
            let modalContext = ForwardTransitionContext(
                presentingModalViewController: modalViewController!,
                inNavigationController: navigationController,
                targetTransitionsHandler: navigationTransitionsHandler,
                animator: animator)
            
            return modalContext
        }
    }
    
    final func presentPopoverFromRect(
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
    
    final func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
    {
        transitionsHandler.performTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let navigationController = UINavigationController()
            let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
            
            // приходится делать optional, иначе `variable captured by a closure before being initialized`
            var presentedViewController: UIViewController? = nil
            
            navigationTransitionsHandler.resetWithTransition(contextCreationClosure: { (generatedTransitionId) -> ForwardTransitionContext in
                let viewController = closure(
                    transitionId: generatedTransitionId,
                    transitionsHandler: navigationTransitionsHandler)
                
                let resetContext = ForwardTransitionContext(
                    resetingWithViewController: viewController,
                    transitionsHandler: navigationTransitionsHandler,
                    animator: resetAnimator)
                
                presentedViewController = viewController
                
                return resetContext
            })
            
            assert(presentedViewController != nil)
            
            let popoverController = navigationController.wrappedInPopoverController()
            
            let popoverContext = ForwardTransitionContext(
                presentingViewController: presentedViewController!,
                inNavigationController: navigationController,
                inPopoverController: popoverController,
                fromRect: rect,
                inView: view,
                targetTransitionsHandler: navigationTransitionsHandler,
                animator: animator)
            
            return popoverContext
        }
    }
    
    final func presentPopoverFromBarButtonItem(
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
    
    final func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator,
        resetAnimator: TransitionsAnimator)
    {
        transitionsHandler.performTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let navigationController = UINavigationController()
            let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
            
            // приходится делать optional, иначе `variable captured by a closure before being initialized`
            var presentedViewController: UIViewController? = nil
            
            navigationTransitionsHandler.resetWithTransition(contextCreationClosure: { (generatedTransitionId) -> ForwardTransitionContext in
                let viewController = closure(
                    transitionId: generatedTransitionId,
                    transitionsHandler: navigationTransitionsHandler)
                
                let resetContext = ForwardTransitionContext(
                    resetingWithViewController: viewController,
                    transitionsHandler: navigationTransitionsHandler,
                    animator: resetAnimator)
                
                presentedViewController = viewController
                
                return resetContext
            })
            
            assert(presentedViewController != nil)
            
            let popoverController = navigationController.wrappedInPopoverController()
            
            let popoverContext = ForwardTransitionContext(
                presentingViewController: presentedViewController!,
                inNavigationController: navigationController,
                inPopoverController: popoverController,
                fromBarButtonItem: barButtonItem,
                targetTransitionsHandler: navigationTransitionsHandler,
                animator: animator)
            
            return popoverContext
        }
    }
}