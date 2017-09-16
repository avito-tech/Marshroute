import UIKit
import Marshroute

class BasePeekAndPopViewController: BaseViewController
{
    // MARK: - Internal properties
    let peekAndPopUtility: PeekAndPopUtility
    
    // MARK: - Init
    init(peekAndPopUtility: PeekAndPopUtility) {
        self.peekAndPopUtility = peekAndPopUtility
        
        super.init()
    }
    
    deinit {
        debugPrint("\(#function), \(self)")
    }
    
    // MARK: - Override point
    var peekSourceViews: [UIView] {
        return []
    }
    
    @available(iOS 9.0, *)
    func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        // You can override this method to adjust `sourceRect` of a `previewingContext`.
        // Default implementation finds an interactable `UIControl` matching the `location` and simulates a `touchUpInside`
        //
        // If one of your `peekSourceViews` is `UITableView` or any other collection, you should override this method
        // to find view data matching the `location` and invoke its callback,
        // so that `Presenter` can ask `Router` to perform some transition
        //
        // Do not forget to invoke `super` implementation unless your custom implementation succeeds 
        guard let interactableControl = previewingContext.sourceView.interactableControlAt(location: location) else {
             return   
        }
        
        let interactableControlFrameInSourceView = interactableControl.convert(
            interactableControl.bounds,
            to: previewingContext.sourceView
        )
        
        // Improve animations via deselecting the control
        interactableControl.isHighlighted = false
        interactableControl.isSelected = false
        
        // Adjust `sourceRect` to provide non-blur area of `peek` animation
        previewingContext.sourceRect = interactableControlFrameInSourceView
        
        // Simulate user interaction
        interactableControl.sendActions(for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        reregisterForPeekAndPopIfAvailable()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        reregisterForPeekAndPopIfAvailable()
    }
    
    // MARK: - Private    
    private func reregisterForPeekAndPopIfAvailable() {
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPeekAndPop()
            } else {
                unregisterFromPeekAndPop()
            }
        }
    }

    @available(iOS 9.0, *)
    private func registerForPeekAndPop() {
        for peekSourceView in peekSourceViews {
            peekAndPopUtility.register(
                viewController: self,
                forPreviewingInSourceView: peekSourceView,
                onPeek: { [weak self] (previewingContext, location) in
                    self?.startPeekWith(
                        previewingContext: previewingContext,
                        location: location
                    )
                },
                onPreviewingContextChange: nil
            )
        }
    }
    
    @available(iOS 9.0, *)
    private func unregisterFromPeekAndPop() {
        peekAndPopUtility.unregisterViewControllerFromPreviewing(self)
    }
}
