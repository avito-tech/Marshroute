import Foundation

public protocol TransitionsMarker: AnyObject {
    func markTransitionId(_ transitionId: TransitionId, withUserId userId: TransitionUserId)
}
