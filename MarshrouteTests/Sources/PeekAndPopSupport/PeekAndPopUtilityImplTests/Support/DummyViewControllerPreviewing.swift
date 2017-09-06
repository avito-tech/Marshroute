import UIKit

final class DummyViewControllerPreviewing: NSObject, UIViewControllerPreviewing {
    @available(iOS 9.0, *)
    var sourceRect: CGRect {
        get { return _sourceRect }
        set { _sourceRect = newValue }
    }

    let previewingGestureRecognizerForFailureRelationship: UIGestureRecognizer = TestableGestureRecognizer()
    var _sourceRect: CGRect = .zero
    let delegate: UIViewControllerPreviewingDelegate 
    let sourceView: UIView
    
    init(
        delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView)
    {
        self.delegate = delegate
        self.sourceView = sourceView
        
        super.init()
    }
}
