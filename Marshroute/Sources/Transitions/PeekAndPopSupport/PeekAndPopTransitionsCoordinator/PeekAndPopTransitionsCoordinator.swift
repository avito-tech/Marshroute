import UIKit

/// This protocol is used by `Marshroute` transitions coordinating system 
/// to allow intercepting transitions during active `peek` sessions.
/// More on this in `PeekAndPopUtility`
public protocol PeekAndPopTransitionsCoordinator: class {
    func coordinatePeekIfNeededFor(
        viewController: UIViewController,
        popAction: @escaping (() -> ()))
}
