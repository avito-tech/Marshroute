import Foundation

protocol TransitionsAnimatorClient: class {
    func launchAnimatingOfPerformingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    func launchAnimatingOfUndoingTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
    func launchAnimatingOfResettingWithTransition(launchingContext launchingContext: TransitionAnimationLaunchingContext)
}