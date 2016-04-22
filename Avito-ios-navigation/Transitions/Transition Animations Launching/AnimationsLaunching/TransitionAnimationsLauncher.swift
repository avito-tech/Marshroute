public protocol TransitionAnimationsLauncher: class {
    func launchPresentationAnimation(
        launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox)
 
    func launchDismissalAnimation(
        launchingContextBox launchingContextBox: DismissalAnimationLaunchingContextBox)
    
    func launchResettingAnimation(
        launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox)
}