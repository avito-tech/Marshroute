import UIKit

struct PeekRequestData {
    weak var previewingContext: UIViewControllerPreviewing?
    weak var sourceViewController: UIViewController?
    let peekLocation: CGPoint
}
