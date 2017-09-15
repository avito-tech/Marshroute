import UIKit

protocol PeekAndPopData {
    var peekViewController: UIViewController? { get }
    var sourceViewController: UIViewController? { get }
    
    var previewingContext: UIViewControllerPreviewing? { get }
    var peekLocation: CGPoint { get }
    
    var popAction: (() -> ()) { get }
}

protocol PeekAndPopDataHolder {
    var peekAndPopData: PeekAndPopData { get }
}

extension PeekAndPopData where Self: PeekAndPopDataHolder {
    var peekViewController: UIViewController? {
        return peekAndPopData.peekViewController
    }
    
    var sourceViewController: UIViewController? {
        return peekAndPopData.sourceViewController
    }
    
    var previewingContext: UIViewControllerPreviewing? {
        return peekAndPopData.previewingContext   
    }
    
    var peekLocation: CGPoint {
        return peekAndPopData.peekLocation
    }
    
    var popAction: (() -> ()) {
        return peekAndPopData.popAction
    }
}

struct WeakPeekAndPopData: PeekAndPopData {
    weak var peekViewController: UIViewController?
    weak var sourceViewController: UIViewController?
   
    weak var previewingContext: UIViewControllerPreviewing?
    let peekLocation: CGPoint
    
    let popAction: (() -> ())
}

struct StrongPeekAndPopData: PeekAndPopData, PeekAndPopDataHolder {
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

