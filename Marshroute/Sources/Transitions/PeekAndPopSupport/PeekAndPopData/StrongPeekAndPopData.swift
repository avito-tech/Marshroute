import UIKit

final class StrongPeekAndPopData: PeekAndPopData, PeekAndPopDataHolder {
    // MARK: - properties
    let strongPeekViewController: UIViewController
    let strongSourceViewController: UIViewController
    
    let strongPreviewingContext: UIViewControllerPreviewing
    let strongPeekLocation: CGPoint
    
    let strongPopAction: (() -> ())
    
    // MARK: - Init
    init(
        peekViewController: UIViewController,
        sourceViewController: UIViewController,
        previewingContext: UIViewControllerPreviewing,
        peekLocation: CGPoint,
        popAction: @escaping (() -> ()))
    {
         strongPeekViewController = peekViewController
         strongSourceViewController = sourceViewController 
         strongPreviewingContext = previewingContext
         strongPeekLocation = peekLocation
         strongPopAction = popAction
    }
    
    // MARK: - Internal
    func toWeakPeekAndPopData() -> WeakPeekAndPopData {
        return WeakPeekAndPopData(
            peekViewController: strongPeekViewController,
            sourceViewController: strongSourceViewController,
            previewingContext: strongPreviewingContext,
            peekLocation: strongPeekLocation,
            popAction: strongPopAction
        )
    }
    
    // MARK: - PeekAndPopDataHolder
    var peekAndPopData: PeekAndPopData {
        return toWeakPeekAndPopData()
    }
}
