public protocol TransitionAnimationsLauncher: class {
    func launchPresentationAnimation(
        inout launchingContextBox launchingContextBox: PresentationAnimationLaunchingContextBox)
 
    func launchDismissalAnimation(
        launchingContextBox launchingContextBox: DismissalAnimationLaunchingContextBox)
    
    func launchResettingAnimation(
        inout launchingContextBox launchingContextBox: ResettingAnimationLaunchingContextBox)
}