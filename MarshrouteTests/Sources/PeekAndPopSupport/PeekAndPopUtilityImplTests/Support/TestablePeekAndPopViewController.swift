import UIKit

final class TestablePeekAndPopViewController: UIViewController {
    override func registerForPreviewing(
        with delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView)
        -> UIViewControllerPreviewing
    {
        return DummyViewControllerPreviewing(
            delegate: delegate,
            sourceView: sourceView
        )
    }
}
