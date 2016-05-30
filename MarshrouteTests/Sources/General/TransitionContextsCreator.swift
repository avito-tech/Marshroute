import UIKit

final class TransitionContextsCreator
{
    static func createCompletedTransitionContextFromPresentationTransitionContext(
        sourceTransitionsHandler sourceTransitionsHandler: AnimatingTransitionsHandler,
        targetViewController: UIViewController,
        targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
        -> CompletedTransitionContext
    {
        let pushAnimationLaunchingContext = PushAnimationLaunchingContext(
            targetViewController: targetViewController,
            animator: NavigationTransitionsAnimator()
        )
        
        let presentationAnimationLaunchingContextBox = PresentationAnimationLaunchingContextBox.Push(
            launchingContext: pushAnimationLaunchingContext
        )
        
        let sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox
            = .Presentation(launchingContextBox: presentationAnimationLaunchingContextBox)
        
        return CompletedTransitionContext(
            transitionId: TransitionIdGeneratorImpl().generateNewTransitionId(),
            sourceTransitionsHandler: sourceTransitionsHandler,
            targetViewController: targetViewController,
            targetTransitionsHandlerBox: targetTransitionsHandlerBox,
            storableParameters: nil,
            sourceAnimationLaunchingContextBox: sourceAnimationLaunchingContextBox
        )
    }
    
    static func createRegisteringCompletedTransitionContext(
        sourceTransitionsHandler sourceTransitionsHandler: AnimatingTransitionsHandler,
                                 targetViewController: UIViewController,
                                 targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
        -> CompletedTransitionContext
    {
        let sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox
            = .Resetting(launchingContextBox: .Registering)
        
        return CompletedTransitionContext(
            transitionId: TransitionIdGeneratorImpl().generateNewTransitionId(),
            sourceTransitionsHandler: sourceTransitionsHandler,
            targetViewController: targetViewController,
            targetTransitionsHandlerBox: targetTransitionsHandlerBox,
            storableParameters: nil,
            sourceAnimationLaunchingContextBox: sourceAnimationLaunchingContextBox
        )
    }
    
    static func createPresentationTransitionContext() -> PresentationTransitionContext {
        return PresentationTransitionContext(
            pushingViewController: UIViewController(),
            animator: NavigationTransitionsAnimator(),
            transitionId: TransitionIdGeneratorImpl().generateNewTransitionId()
        )
    }
    
    static func createRegisteringEndpointNavigationControllerTransitionContext() -> ResettingTransitionContext {
        return ResettingTransitionContext(
            registeringEndpointNavigationController: UINavigationController(), animatingTransitionsHandler: NavigationTransitionsHandlerImpl(
                navigationController: UINavigationController(),
                transitionsCoordinator: TransitionsCoordinatorImpl(
                    stackClientProvider: TransitionContextsStackClientProviderImpl()
                )
            ),
            transitionId: TransitionIdGeneratorImpl().generateNewTransitionId()
        )
    }
}