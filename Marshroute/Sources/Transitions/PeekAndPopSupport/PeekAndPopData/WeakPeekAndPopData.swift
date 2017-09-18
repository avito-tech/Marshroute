import UIKit

final class WeakPeekAndPopData: PeekAndPopData {
    // MARK: - properties
    weak var peekViewController: UIViewController?
    weak var sourceViewController: UIViewController?
   
    weak var previewingContext: UIViewControllerPreviewing?
    let peekLocation: CGPoint
    
    let popAction: (() -> ())
    
    // MARK: - Init
    init(
        peekViewController: UIViewController,
        sourceViewController: UIViewController,
        previewingContext: UIViewControllerPreviewing,
        peekLocation: CGPoint,
        popAction: @escaping (() -> ()))
    {
        self.peekViewController = peekViewController
        self.sourceViewController = sourceViewController 
        self.previewingContext = previewingContext
        self.peekLocation = peekLocation
        self.popAction = popAction
    }
}
