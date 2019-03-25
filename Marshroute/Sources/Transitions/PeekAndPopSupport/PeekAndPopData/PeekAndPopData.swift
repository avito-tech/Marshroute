import UIKit

protocol PeekAndPopData {
    var peekViewController: UIViewController? { get }
    var sourceViewController: UIViewController? { get }
    
    var previewingContext: UIViewControllerPreviewing? { get }
    var peekLocation: CGPoint { get }
    
    var popAction: (() -> ()) { get }
}
