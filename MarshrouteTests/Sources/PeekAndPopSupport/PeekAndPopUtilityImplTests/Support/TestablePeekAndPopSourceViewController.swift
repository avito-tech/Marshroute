import UIKit

final class TestablePeekAndPopSourceViewController: UIViewController {
    var shouldStartSpying = false
    
    var registerForPreviewingCalledCount = 0 
    
    override func registerForPreviewing(
        with delegate: UIViewControllerPreviewingDelegate,
        sourceView: UIView)
        -> UIViewControllerPreviewing
    {
        if shouldStartSpying {
            registerForPreviewingCalledCount += 1
        }
        
        return super.registerForPreviewing(
            with: delegate,
            sourceView: sourceView
        )
    }
    
    var unregisterForPreviewingCalledCount = 0
    
    override func unregisterForPreviewing(
        withContext previewing: UIViewControllerPreviewing)
    {
        if shouldStartSpying {
            unregisterForPreviewingCalledCount += 1
        }
        
        super.unregisterForPreviewing(
            withContext: previewing
        )
    }
}
