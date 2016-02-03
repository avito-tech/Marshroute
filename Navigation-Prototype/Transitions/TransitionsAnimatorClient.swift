import Foundation

protocol TransitionsAnimatorClient: class {
    func launchAnimatingOfPerformingTransition(launchingContext context: TransitionAnimationLaunchingContext)
    func launchAnimatingOfUndoingTransition(launchingContext context: TransitionAnimationLaunchingContext)
    func launchAnimatingOfResettingWithTransition(launchingContext context: TransitionAnimationLaunchingContext)
}