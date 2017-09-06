import Foundation

public protocol TransitionsCoordinatorDelegateHolder: class {
    weak var transitionsCoordinatorDelegate: TransitionsCoordinatorDelegate? { get set }
}
