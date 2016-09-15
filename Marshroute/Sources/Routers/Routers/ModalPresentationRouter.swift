import UIKit

/// Роутер, выполняющий модальные переходы на  UIViewController, как обернутый, так и необернутый в UINavigationController.
/// Также выполняет модальные переходы на UISplitViewController
public protocol ModalPresentationRouter: class {
    // MARK: - UIViewController
    func presentModalViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
         animator: ModalTransitionsAnimator)
    
    // MARK: - UISplitViewController
    func presentModalMasterDetailViewControllerDerivedFrom(
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalMasterDetailTransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalMasterDetailTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)

    // MARK: - UIViewController in UINavigationController
    func presentModalNavigationControllerWithRootViewControllerDerivedFrom(
        _ deriveRootViewController: (_ routerSeed: RouterSeed) -> UIViewController)

    func presentModalNavigationControllerWithRootViewControllerDerivedFrom(
        _ deriveRootViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalNavigationTransitionsAnimator)

    func presentModalNavigationControllerWithRootViewControllerDerivedFrom(
        _ deriveRootViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalNavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - ModalPresentationRouter Default Impl
extension ModalPresentationRouter where
    Self: RouterTransitionable,
    Self: RouterIdentifiable,
    Self: TransitionIdGeneratorHolder,
    Self: TransitionsHandlersProviderHolder,
    Self: RouterControllersProviderHolder
{
    // MARK: - UIViewController
    public func presentModalViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: ModalTransitionsAnimator()
        )
    }
    
    public func presentModalViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalTransitionsAnimator)
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
        
        let modalContext = PresentationTransitionContext(
            presentingModalViewController: viewController,
            targetTransitionsHandler: animatingTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        presentingTransitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
    
    // MARK: - UISplitViewController
    public func presentModalMasterDetailViewControllerDerivedFrom(
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: ModalMasterDetailTransitionsAnimator()
        )
    }
    
    public func presentModalMasterDetailViewControllerDerivedFrom(
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalMasterDetailTransitionsAnimator)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: animator,
            masterNavigationController: controllersProvider.navigationController(),
            detailNavigationController: controllersProvider.navigationController(),
            splitViewController: controllersProvider.splitViewController()
        )
    }
    
    public func presentModalMasterDetailViewControllerDerivedFrom(
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalMasterDetailTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)
    {
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let masterTransitionsHandler = transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: masterNavigationController
        )
        
        let detailTransitionsHandler = transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: detailNavigationController
        )
        
        let masterTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: masterTransitionsHandler
        )
        
        let detailTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: detailTransitionsHandler
        )
        
        let splitViewTransitionsHandler = transitionsHandlersProvider.splitViewTransitionsHandler(
            splitViewController: splitViewController
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        let presentingTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: transitionsHandlerBox
        )
        
        // один на master и detail модули. см описание `TransitionId`
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()

        do {
            let masterRouterSeed = MasterDetailRouterSeed(
                masterTransitionsHandlerBox: masterTransitionsHandlerBox,
                detailTransitionsHandlerBox: detailTransitionsHandlerBox,
                transitionId: generatedTransitionId,
                presentingTransitionsHandler: presentingTransitionsHandlerBox.unbox(),
                transitionsHandlersProvider: transitionsHandlersProvider,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: controllersProvider
            )
            
            let masterViewController = deriveMasterViewController(masterRouterSeed)
            
            let resetMasterContext = ResettingTransitionContext(
                settingRootViewController: masterViewController,
                forNavigationController: masterNavigationController,
                animatingTransitionsHandler: masterTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: generatedTransitionId
            )
            
            masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
        }
        
        do {
            let detailRouterSeed = RouterSeed(
                transitionsHandlerBox: detailTransitionsHandlerBox,
                transitionId: generatedTransitionId,
                presentingTransitionsHandler: transitionsHandlerBox.unbox(),
                transitionsHandlersProvider: transitionsHandlersProvider,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: controllersProvider
            )
            
            let detailViewController = deriveDetailViewController(detailRouterSeed)
            
            let resetDetailContext = ResettingTransitionContext(
                settingRootViewController: detailViewController,
                forNavigationController: detailNavigationController,
                animatingTransitionsHandler: detailTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: generatedTransitionId
            )
            
            detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
        }
        
        let modalContext = PresentationTransitionContext(
            presentingModalMasterDetailViewController: splitViewController,
            targetTransitionsHandler: splitViewTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        presentingTransitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
    
    // MARK: - UIViewController in UINavigationController
    public func presentModalNavigationControllerWithRootViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        presentModalNavigationControllerWithRootViewControllerDerivedFrom(
            deriveViewController,
            animator: ModalNavigationTransitionsAnimator()
        )
    }

    public func presentModalNavigationControllerWithRootViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalNavigationTransitionsAnimator)
    {
        presentModalNavigationControllerWithRootViewControllerDerivedFrom(
            deriveViewController,
            animator: animator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentModalNavigationControllerWithRootViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ModalNavigationTransitionsAnimator,
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
        
        let modalContext = PresentationTransitionContext(
            presentingModalViewController: viewController,
            inNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )

        presentingTransitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
}
