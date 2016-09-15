public protocol TransitionAnimationsLauncher: class {
    func launchPresentationAnimation(
        launchingContextBox: inout PresentationAnimationLaunchingContextBox)
 
    func launchDismissalAnimation(
        launchingContextBox: DismissalAnimationLaunchingContextBox)
    
    func launchResettingAnimation(
        launchingContextBox: inout ResettingAnimationLaunchingContextBox)
}
