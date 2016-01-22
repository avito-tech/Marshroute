import UIKit

class MasterRouter: BaseRouter {
    var detailTransitionsHandler: TransitionsHandler?
    
    func setDetailViewController(
        viewController: UIViewController,
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        guard let detailTransitionsHandler = detailTransitionsHandler
            else { assert(false); return }
        
        let targetTransitionsHandler = detailTransitionsHandler
        
        let context = ForwardTransitionContext(
            pushingViewController: viewController,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        detailTransitionsHandler.undoAllTransitionsAndResetWithTransition(context)
    }
}
