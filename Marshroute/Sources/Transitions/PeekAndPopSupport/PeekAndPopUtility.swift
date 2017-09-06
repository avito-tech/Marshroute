import UIKit

public protocol PeekAndPopUtility: class {
    @available(iOS 9.0, *)
    func register(
        viewController: UIViewController, 
        forPreviewingInSourceView sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
    
    @available(iOS 9.0, *)
    /// Pass nil to unregister for all source views
    func unregister(
        viewController: UIViewController,
        fromPreviewingInSourceView sourceView: UIView?)
}

public extension PeekAndPopUtility {
    @available(iOS 9.0, *)
    @discardableResult
    func reregister(
        viewController: UIViewController, 
        forPreviewingInSourceView sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
    {
        unregister(
            viewController: viewController,
            fromPreviewingInSourceView: sourceView
        )
        
        register(
            viewController: viewController,
            forPreviewingInSourceView: sourceView,
            onPeek: onPeek,
            onPreviewingContextChange: onPreviewingContextChange
        )   
    }
    
    @available(iOS 9.0, *)
    func unregisterViewControllerFromPreviewing(_ viewController: UIViewController) {
        unregister(
            viewController: viewController,
            fromPreviewingInSourceView: nil
        )
    }
}
