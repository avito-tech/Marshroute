import Foundation

public protocol TransitionsCoordinatorDelegateHolder: AnyObject {
    var transitionsCoordinatorDelegate: TransitionsCoordinatorDelegate? { get set }
}
