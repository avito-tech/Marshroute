import Foundation

public protocol TransitionsMarkersHolder: AnyObject {
    var markers: [TransitionId: TransitionUserId] { get set }
}
