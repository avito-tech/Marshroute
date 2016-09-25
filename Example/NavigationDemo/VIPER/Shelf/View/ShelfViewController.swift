import UIKit

final class ShelfViewController: BaseViewController, ShelfViewInput {
    fileprivate let shelfView = ShelfView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = shelfView
    }
    
    // MARK: - ShelfViewInput
    @nonobjc func setTitle(_ title: String?) {
        self.title = title
    }
}
