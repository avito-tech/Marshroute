public protocol TransitionAnimationsLauncher: class {
    func launchAnimationOfPerformingTransition(
        launchingContext launchingContext: PresentationAnimationLaunchingContext)
 
    func launchAnimationOfUndoingTransition(
        launchingContext launchingContext: DismissalAnimationLaunchingContext)
    
    func launchAnimationOfResettingWithTransition(
        launchingContext launchingContext: PresentationAnimationLaunchingContext)
}