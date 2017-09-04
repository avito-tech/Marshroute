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
    
    // MARK: - Override point
    var peekSourceView: UIView {
        assert(isViewLoaded)
        return view
    }
    
    func startPeekWith(
        previewingContext: UIViewControllerPreviewing,
        location: CGPoint)
    {
        // Override to adjust `sourceRect` of a `previewingContext`,
        // find view data matching the location
        // and invoke its callback, so that `Presenter` can ask `Router` to perform some transition 
    }
    
    // MARK: - Lifecycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPeekAndPop()
            } else {
                unregisterFromPeekAndPop()
            }
        }
    }
    
    // MARK: - Private
    private func registerForPeekAndPop() {
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                peekAndPopUtility.register(
                    viewController: self,
                    sourceView: peekSourceView,
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
    }
    
    private func unregisterFromPeekAndPop() {
        if #available(iOS 9.0, *) {
            peekAndPopUtility.unregister(viewController: self)
        }
    }
}
