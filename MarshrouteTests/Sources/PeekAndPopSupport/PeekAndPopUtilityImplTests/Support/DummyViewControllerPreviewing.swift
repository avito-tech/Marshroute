import UIKit

final class DummyViewControllerPreviewing: NSObject, UIViewControllerPreviewing {
    @available(iOS 9.0, *)
    var sourceRect: CGRect {
        get { return _sourceRect }
        set { _sourceRect = newValue }
    }

    var delegate: UIViewControllerPreviewingDelegate {
        return _delegate!
    }
    
    weak var _delegate: UIViewControllerPreviewingDelegate?

    let previewingGestureRecognizerForFailureRelationship: UIGestureRecognizer = TestableGestureRecognizer()
    var _sourceRect: CGRect = .zero
    let sourceView: UIView
    
    init(
        delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView)
    {
        self._delegate = delegate
        self.sourceView = sourceView
        
        super.init()
    }
    
    func unregister() {
        // Required to avoid the following crash:
        // `[MarshrouteTests.DummyViewControllerPreviewing unregister]: unrecognized selector sent to instance ...`
        // 
        // It occures during unregistering view controller from previewing:
        // `viewController.unregisterForPreviewing(withContext: previewingContext)`
    }
}
