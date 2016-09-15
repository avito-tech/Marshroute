import UIKit

/// Роутер, выполняющий модальные переходы на конечный UINavigationController.
/// Например, на MFMailComposeViewController, UIImagePickerController
public protocol EndpointRouter: class {
    func presentModalEndpointNavigationController(
        _ navigationController: UINavigationController,
        prepareForTransition: (_ routerSeed: RouterSeed) -> ())
    
    func presentModalEndpointNavigationController(
        _ navigationController: UINavigationController,
        animator: ModalEndpointNavigationTransitionsAnimator,
        prepareForTransition: (_ routerSeed: RouterSeed) -> ())
}

// MARK: - EndpointRouter Default Impl
extension EndpointRouter where
    Self: RouterTransitionable,
    Self: RouterIdentifiable,
    Self: TransitionIdGeneratorHolder,
    Self: TransitionsHandlersProviderHolder,
    Self: RouterControllersProviderHolder
{
    public func presentModalEndpointNavigationController(
        _ navigationController: UINavigationController,
        prepareForTransition: (_ routerSeed: RouterSeed) -> ())
    {
        presentModalEndpointNavigationController(
            navigationController,
            animator: ModalEndpointNavigationTransitionsAnimator(),
            prepareForTransition: prepareForTransition
        )
    }
    
    public func presentModalEndpointNavigationController(
        _ navigationController: UINavigationController,
        animator: ModalEndpointNavigationTransitionsAnimator,
        prepareForTransition: (_ routerSeed: RouterSeed) -> ())
    {
        let navigationTransitionsHandler = transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
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
        
        prepareForTransition(routerSeed)
        
        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
}
