import UIKit

final class TransitionContextsCreator
{
    static func createPerformingCompletedTransitionContext(
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
        
        let sourceAnimationLaunchingContextBox: CompletedTransitionContextSourceAnimationLaunchingContextBox
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
        let sourceAnimationLaunchingContextBox: CompletedTransitionContextSourceAnimationLaunchingContextBox
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
}