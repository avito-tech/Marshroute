import UIKit


/// Описание параметров запуска любого вида анимаций сокрытия
public enum DismissalAnimationLaunchingContext {
    case Modal(launchingContext: ModalDismissalAnimationLaunchingContext)
    case ModalNavigation(launchingContext: ModalNavigationDismissalAnimationLaunchingContext)
    case Pop(launchingContext: PopAnimationLaunchingContext)
    case Popover(launchingContext: PopoverDismissalAnimationLaunchingContext)
    case PopoverNavigation(launchingContext: PopoverNavigationDismissalAnimationLaunchingContext)
}
