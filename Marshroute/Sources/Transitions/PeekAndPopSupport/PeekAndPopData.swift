import UIKit

struct PeekAndPopData {
    weak var peekViewController: UIViewController?
    weak var sourceViewController: UIViewController?
    let peekLocation: CGPoint
    
    weak var previewingContext: UIViewControllerPreviewing?
    let popAction: (() -> ())
}
