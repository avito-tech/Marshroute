import Foundation

public protocol TransitionsMarker: class {
    func markTransitionId(transitionId: TransitionId, withUserId userId: TransitionUserId)
}
