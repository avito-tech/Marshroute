protocol TransitionAnimationLaunchingContextConverter: class {
    func convertAnimationLaunchingContextToAnimationContext(context: TransitionAnimationLaunchingContext)
    -> TransitionAnimationContext?
}