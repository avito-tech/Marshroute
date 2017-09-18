import UIKit

protocol PeekAndPopData {
    weak var peekViewController: UIViewController? { get }
    weak var sourceViewController: UIViewController? { get }
    
    weak var previewingContext: UIViewControllerPreviewing? { get }
    var peekLocation: CGPoint { get }
    
    var popAction: (() -> ()) { get }
}
