import Marshroute

final class BottomSheetModalAnimator: ModalTransitionsAnimator {
    private let transition: BottomSheetTransition
    
    init(
        configuration: BottomSheetTransitionConfiguration = BottomSheetTransitionConfiguration())
    {
        transition = BottomSheetTransition(withConfiguration: configuration)
        super.init(targetModalTransitionStyle: nil, targetModalPresentationStyle: .custom)
    }
    
    override func animatePerformingTransition(animationContext context: ModalPresentationAnimationContext) {
        context.targetViewController.transitioningDelegate = transition
        super.animatePerformingTransition(animationContext: context)
    }
}
