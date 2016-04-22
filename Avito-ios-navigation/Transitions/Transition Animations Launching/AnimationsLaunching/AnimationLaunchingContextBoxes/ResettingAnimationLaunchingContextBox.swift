import UIKit

/// Описание параметров запуска reset-анимаций
public enum ResettingAnimationLaunchingContextBox {
    case SetNavigation(launchingContext: SettingAnimationLaunchingContext)
    case ResetNavigation(launchingContext: ResettingAnimationLaunchingContext)
    case Reset
    
    public var resettingTransitionsAnimatorBox: ResettingTransitionsAnimatorBox
    {
        switch self {
        case .SetNavigation(let launchingContext):
            return .SetNavigation(animator: launchingContext.animator)
            
        case .ResetNavigation(let launchingContext):
            return .ResetNavigation(animator: launchingContext.animator)
            
        case .Reset:
            return .Reset
        }
    }
    
    public mutating func appendSourceViewController(sourceViewController: UIViewController)
    {
        switch self {
        case .SetNavigation(_):
            break // has no source view controller property
            
        case .ResetNavigation(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            
        case .Reset:
            break // no need for animations
        }
    }
}