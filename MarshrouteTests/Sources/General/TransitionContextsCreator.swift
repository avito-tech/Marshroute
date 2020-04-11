import UIKit
@testable import Marshroute

final class TransitionContextsCreator
{
    static func createCompletedTransitionContextFromPresentationTransitionContext(
        sourceTransitionsHandler: AnimatingTransitionsHandler,
        sourceViewController: UIViewController,
        targetViewController: UIViewController,
        navigationController: UINavigationController?,
        targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
        -> CompletedTransitionContext
    {
        var pushAnimationLaunchingContext = PushAnimationLaunchingContext(
            targetViewController: targetViewController,
            animator: NavigationTransitionsAnimator()
        )
        
        pushAnimationLaunchingContext.sourceViewController = sourceViewController
        pushAnimationLaunchingContext.navigationController = navigationController
        
        let presentationAnimationLaunchingContextBox = PresentationAnimationLaunchingContextBox.push(
            launchingContext: pushAnimationLaunchingContext
        )
        
        let sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox
            = .presentation(launchingContextBox: presentationAnimationLaunchingContextBox)
        
        navigationController?.pushViewController(targetViewController, animated: false)
        
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
        sourceTransitionsHandler: AnimatingTransitionsHandler,
        targetViewController: UIViewController,
        targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
        -> CompletedTransitionContext
    {
        let sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox
            = .resetting(launchingContextBox: .registering)
        
//        let resettingAnimationLaunchingContextBox = ResettingAnimationLaunchingContextBox.settingNavigationRoot(
//            launchingContext: <#T##SettingAnimationLaunchingContext#>)(
//        
//        
//        sourceTransitionsHandler.launchResettingAnimation(
//            launchingContextBox: &sourceAnimationLaunchingContextBox
//        )
        
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
                    stackClientProvider: TransitionContextsStackClientProviderImpl(),
                    peekAndPopTransitionsCoordinator: PeekAndPopUtilityImpl()
                )
            ),
            transitionId: TransitionIdGeneratorImpl().generateNewTransitionId()
        )
    }
}
