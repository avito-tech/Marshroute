import UIKit

/// Роутер, выполняющий модальные переходы на конечный UINavigationController.
/// Например, на MFMailComposeViewController, UIImagePickerController
public protocol EndpointRouter: AnyObject {
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
    Self: RouterControllersProviderHolder,
    Self: RouterTransitionDelegateHoder
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
        
        routerTransitionDelegate?.routerWillPerformTransitionWith(transitionId: generatedTransitionId)
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            routerTransitionDelegate: routerTransitionDelegate
        )
        
        do {
            let resetContext = ResettingTransitionContext(
                registeringEndpointNavigationController: navigationController,
                navigationTransitionsHandler: navigationTransitionsHandler,
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
