import Foundation

public protocol TransitionsCoordinatorDelegateHolder: class {
    var transitionsCoordinatorDelegate: TransitionsCoordinatorDelegate? { get set }
}
