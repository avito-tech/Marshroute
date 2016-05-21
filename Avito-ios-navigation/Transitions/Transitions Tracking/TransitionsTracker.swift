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
        trackedTransition: TrackedTransition,
        untilLastTransitionOfTransitionsHandler targetTransitionsHandler: TransitionsHandler)
        -> Int?
}