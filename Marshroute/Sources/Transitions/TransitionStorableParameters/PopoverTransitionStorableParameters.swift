import UIKit

final class PopoverTransitionStorableParameters: NSObject, TransitionStorableParameters {
    /// если показывать дочерний контроллер внутри поповера,
    /// то кто-то должен держать сильную ссылку на этот поповер
    fileprivate(set) var popoverController: UIPopoverController? {
        willSet {
            // старые версии iOS крешились, если не убирать зануляемый поповер
            if newValue == nil {
                popoverController?.dismiss(animated: false)
            }
        }
    }
    
    /// дочерний контроллер как правило - UINavigationController,
    /// поэтому кто-то должен держать сильную ссылку на его обработчика переходов.
    /// роутеры держат слабые ссылки на свои обработчики переходов
    let presentedTransitionsHandler: TransitionsHandler
    
    init (
        popoverController: UIPopoverController,
        presentedTransitionsHandler: TransitionsHandler)
    {
        self.popoverController = popoverController
        self.presentedTransitionsHandler = presentedTransitionsHandler
        
        super.init()
        
        popoverController.delegate = self
    }
}

// MARK: - UIPopoverControllerDelegate
extension PopoverTransitionStorableParameters: UIPopoverControllerDelegate {
    func popoverControllerDidDismissPopover(_ popoverController: UIPopoverController)
    {
        self.popoverController = nil
    }
}
