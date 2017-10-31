import UIKit

final class ShelfViewController: BaseViewController, ShelfViewInput {
    private let shelfView = ShelfView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = shelfView
    }
    
    // MARK: - ShelfViewInput
    @nonobjc func setTitle(_ title: String?) {
        self.title = title
    }
}
