import UIKit

public protocol EndPointRouter: class {
    func presentModalNavigationController(
        navigationController: UINavigationController,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
    
    func presentModalNavigationController(
        navigationController: UINavigationController,
        animator: EndPointNavigationTransitionsAnimator,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
}

// MARK: - EndPointRouter Default Impl
extension EndPointRouter where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder, Self: RouterControllersProviderHolder {
    
    public func presentModalNavigationController(
        navigationController: UINavigationController,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
    {
        presentModalNavigationController(
            navigationController,
            animator: EndPointNavigationTransitionsAnimator(),
            prepareForTransition: prepareForTransition
        )
    }
    
    public func presentModalNavigationController(
        navigationController: UINavigationController,
        animator: EndPointNavigationTransitionsAnimator,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
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
        
        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: navigationController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        prepareForTransition(routerSeed: routerSeed)
        
        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
}