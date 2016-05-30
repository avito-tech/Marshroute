import Foundation

public protocol TransitionsMarkersHolder: class {
    var markers: [TransitionId: TransitionUserId] { get set }
}
