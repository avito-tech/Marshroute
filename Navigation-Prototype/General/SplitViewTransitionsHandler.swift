import UIKit

class SplitViewTransitionsHandler {
    private let splitViewController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandler: TransitionsHandler {}

