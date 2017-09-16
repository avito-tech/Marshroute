import UIKit

/// This utility is intended to be used in view controllers to register them as capable of previewing other controllers.
/// The implementation of this utility wraps `UIViewControllerPreviewingDelegate` and implements `PeekAndPopTransitionsCoordinator` protocol.
/// It is used by `Marshroute` to check whether any transition is performed within an active `peek` session.
/// (i.e. when `UIKit` asks `UIViewControllerPreviewingDelegate` for a view controller to be previewed.
///
/// If so, the transition will get frozen and the following things will occur:
/// 1. A target view controller will be presented in a preview mode (`peek` mode)
/// 2. The transition will be continued only if a user commits the `peek` (i.e. the view controller gets `popped`).
/// 
/// If no active `peek` session exists, the transition will be performed as usually (without any intercepting)
public protocol PeekAndPopUtility: class {
    /// Use this function to register your view controller for previewing.
    ///
    /// In your `onPeek` closure you should do the following things:
    /// 1. Adjust the `sourceRect` of a passed `UIViewControllerPreviewing` object (for blur animation).
    /// 2. Start a transition to some view controller, which will be previewed. 
    ///
    /// If you invoke no transition within `onPeek` closure, or invoke an asynchronous transition, no `peek` will occur.
    /// This behavior is a result of `UIKit` Api restrictions:
    /// `UIViewControllerPreviewingDelegate` is required to return a previewing view controller synchronously.
    ///
    /// You can also use `onPreviewingContextChange` closure to set up your gesture recognizer failure relationships.
    @available(iOS 9.0, *)
    func register(
        viewController: UIViewController, 
        forPreviewingInSourceView sourceView: UIView,
        onPeek: @escaping ((_ previewingContext: UIViewControllerPreviewing, _ location: CGPoint) -> ()),
        onPreviewingContextChange: ((_ newPreviewingContext: UIViewControllerPreviewing) -> ())?)
    
    @available(iOS 9.0, *)
    func unregister(
        viewController: UIViewController,
        fromPreviewingInSourceView sourceView: UIView?)
}

public extension PeekAndPopUtility {
    @available(iOS 9.0, *)
    func unregisterViewControllerFromPreviewingInAllSourceViews(_ viewController: UIViewController) {
        unregister(
            viewController: viewController,
            fromPreviewingInSourceView: nil
        )
    }
    
    @available(iOS 9.0, *)
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
