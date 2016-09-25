import Foundation

public struct TrackedTransition {
    public let transitionId: TransitionId
    public let transitionsHandlerBox: TransitionsHandlerBox
    
    public init(
        transitionId: TransitionId,
        transitionsHandlerBox: TransitionsHandlerBox)
    {
        self.transitionId = transitionId
        self.transitionsHandlerBox = transitionsHandlerBox
    }
}

public protocol TransitionsTracker: class {
    func countOfTransitionsAfterTrackedTransition(
        _ trackedTransition: TrackedTransition,
        untilLastTransitionOfTransitionsHandler targetTransitionsHandler: TransitionsHandler)
        -> Int?
    
    func restoredTransitionFromTrackedTransition(
        _ trackedTransition: TrackedTransition,
        searchingFromTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
        -> RestoredTransitionContext?
    
    func restoredTransitionFromTrackedTransition(
        _ trackedTransition: TrackedTransition,
        searchingFromTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> RestoredTransitionContext?
}
