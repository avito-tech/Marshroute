import UIKit

struct PopoverTransitionStorableParameters: TransitionStorableParameters {
    /// если показывать дочерний контроллер внутри поповера,
    /// то кто-то должен держать сильную ссылку на этот поповер
    let popoverController: UIPopoverController
}