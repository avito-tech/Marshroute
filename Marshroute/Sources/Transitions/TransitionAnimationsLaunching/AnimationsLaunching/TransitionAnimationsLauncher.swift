public protocol TransitionAnimationsLauncher: AnyObject {
    func launchPresentationAnimation(
        launchingContextBox: inout PresentationAnimationLaunchingContextBox)
 
    func launchDismissalAnimation(
        launchingContextBox: DismissalAnimationLaunchingContextBox)
    
    func launchResettingAnimation(
        launchingContextBox: inout ResettingAnimationLaunchingContextBox)
}
