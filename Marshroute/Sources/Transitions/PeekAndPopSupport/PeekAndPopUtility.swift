import UIKit

public protocol PeekAndPopUtility: class {
    @available(iOS 9.0, *)
    @discardableResult
    func register(
        viewController: UIViewController, 
        sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
        -> UIViewControllerPreviewing
    
    @available(iOS 9.0, *)
    /// Pass nil to unregister for all source views
    func unregister(viewController: UIViewController, sourceView: UIView?)
}

public extension PeekAndPopUtility {
    @available(iOS 9.0, *)
    @discardableResult
    func reregister(
        viewController: UIViewController, 
        sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
        -> UIViewControllerPreviewing
    {
        unregister(
            viewController: viewController,
            sourceView: sourceView
        )
        
        return register(
            viewController: viewController,
            sourceView: sourceView,
            onPeek: onPeek,
            onPreviewingContextChange: onPreviewingContextChange
        )   
    }
    
    @available(iOS 9.0, *)
    func unregister(viewController: UIViewController) {
        unregister(viewController: viewController, sourceView: nil)
    }
}
