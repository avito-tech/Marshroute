import UIKit

struct PopoverTransitionStorableParameters: TransitionStorableParameters {
    /// если показывать дочерний контроллер внутри поповера,
    /// то кто-то должен держать сильную ссылку на этот поповер
    let popoverController: UIPopoverController
    
    /// дочерний контроллер как правило - UINavigationController,
    /// поэтому кто-то должен держать сильную ссылку на его обработчика переходов.
    /// роутеры держат слабые ссылки на свои обработчики переходов
    let presentedTransitionsHandler: TransitionsHandler
}