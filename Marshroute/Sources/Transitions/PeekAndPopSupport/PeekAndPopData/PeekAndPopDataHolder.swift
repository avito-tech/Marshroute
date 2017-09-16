import UIKit

protocol PeekAndPopDataHolder {
    var peekAndPopData: PeekAndPopData { get }
}

extension PeekAndPopData where Self: PeekAndPopDataHolder {
    weak var peekViewController: UIViewController? {
        return peekAndPopData.peekViewController
    }
    
    weak var sourceViewController: UIViewController? {
        return peekAndPopData.sourceViewController
    }
    
    weak var previewingContext: UIViewControllerPreviewing? {
        return peekAndPopData.previewingContext   
    }
    
    var peekLocation: CGPoint {
        return peekAndPopData.peekLocation
    }
    
    var popAction: (() -> ()) {
        return peekAndPopData.popAction
    }
}
