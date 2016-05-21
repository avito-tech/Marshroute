import UIKit

/// Роутер, выполняющий модальные переходы на конечный UINavigationController.
/// Например, на MFMailComposeViewController, UIImagePickerController
public protocol EndpointRouter: class {
    func presentModalEndpointNavigationController(
        navigationController: UINavigationController,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
    
    func presentModalEndpointNavigationController(
        navigationController: UINavigationController,
        animator: ModalEndpointNavigationTransitionsAnimator,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
}

// MARK: - EndpointRouter Default Impl
extension EndpointRouter where
    Self: RouterTransitionable,
    Self: RouterIdentifiable,
    Self: TransitionIdGeneratorHolder,
    Self: TransitionsCoordinatorHolder,
    Self: RouterControllersProviderHolder
{
    public func presentModalEndpointNavigationController(
        navigationController: UINavigationController,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
    {
        presentModalEndpointNavigationController(
            navigationController,
            animator: ModalEndpointNavigationTransitionsAnimator(),
            prepareForTransition: prepareForTransition
        )
    }
    
    public func presentModalEndpointNavigationController(
        navigationController: UINavigationController,
        animator: ModalEndpointNavigationTransitionsAnimator,
        @noescape prepareForTransition: (routerSeed: RouterSeed) -> ())
    {
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
            let resetContext = ResettingTransitionContext(
                registeringEndpointNavigationController: navigationController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                transitionId: transitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let modalContext = PresentationTransitionContext(
            presentingModalEndpointNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        prepareForTransition(routerSeed: routerSeed)
        
        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
}