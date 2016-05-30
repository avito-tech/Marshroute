import UIKit

final class ShelfViewController: BaseViewController, ShelfViewInput {
    private let shelfView = ShelfView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = shelfView
    }
    
    // MARK: - ShelfViewInput
    @nonobjc func setTitle(title: String?) {
        self.title = title
    }
}
