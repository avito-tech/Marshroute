import Marshroute

final class BottomSheetModalNavigationAnimator: ModalNavigationTransitionsAnimator {
    private let transition: BottomSheetTransition
    
    init(
        configuration: BottomSheetTransitionConfiguration = BottomSheetTransitionConfiguration())
    {
        transition = BottomSheetTransition(withConfiguration: configuration)
        super.init(targetModalTransitionStyle: nil, targetModalPresentationStyle: .custom)
    }
    
    override func animatePerformingTransition(animationContext context: ModalNavigationPresentationAnimationContext) {
        context.targetNavigationController.transitioningDelegate = transition
        super.animatePerformingTransition(animationContext: context)
    }
}
