import Foundation

public protocol TransitionsMarker: class {
    func markTransitionId(_ transitionId: TransitionId, withUserId userId: TransitionUserId)
}
