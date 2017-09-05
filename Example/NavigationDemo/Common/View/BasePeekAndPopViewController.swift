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
        assert(isViewLoaded)
        return [view]
    }
    
    @available(iOS 9.0, *)
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
    
    @available(iOS 9.0, *)
    private func unregisterFromPeekAndPop() {
        peekAndPopUtility.unregister(viewController: self)
    }
}
