import UIKit

/// Описание параметров запуска reset-анимаций
public enum ResettingAnimationLaunchingContextBox {
    case SettingNavigationRoot(launchingContext: SettingAnimationLaunchingContext)
    case ResettingNavigationRoot(launchingContext: ResettingAnimationLaunchingContext)
    case Registering
    case RegisteringEndpointNavigation
    
    public var resettingTransitionsAnimatorBox: ResettingTransitionsAnimatorBox
    {
        switch self {
        case .SettingNavigationRoot(let launchingContext):
            return .SettingNavigationRoot(animator: launchingContext.animator)
            
        case .ResettingNavigationRoot(let launchingContext):
            return .ResettingNavigationRoot(animator: launchingContext.animator)
            
        case .Registering:
            return .Registering
            
        case .RegisteringEndpointNavigation:
            return .RegisteringEndpointNavigation
        }
    }
    
    public mutating func appendSourceViewController(sourceViewController: UIViewController)
    {
        switch self {
        case .SettingNavigationRoot(_):
            break // has no source view controller property
            
        case .ResettingNavigationRoot(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .ResettingNavigationRoot(launchingContext: launchingContext)
            
        case .Registering:
            break // no need for animations
            
        case .RegisteringEndpointNavigation:
            break // no need for animations
        }
    }
}