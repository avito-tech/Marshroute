import UIKit

/// Описание параметров запуска reset-анимаций
public enum ResettingAnimationLaunchingContextBox {
    case settingNavigationRoot(launchingContext: SettingAnimationLaunchingContext)
    case resettingNavigationRoot(launchingContext: ResettingAnimationLaunchingContext)
    case registering
    case registeringEndpointNavigation
    
    public var resettingTransitionsAnimatorBox: ResettingTransitionsAnimatorBox
    {
        switch self {
        case .settingNavigationRoot(let launchingContext):
            return .settingNavigationRoot(animator: launchingContext.animator)
            
        case .resettingNavigationRoot(let launchingContext):
            return .resettingNavigationRoot(animator: launchingContext.animator)
            
        case .registering:
            return .registering
            
        case .registeringEndpointNavigation:
            return .registeringEndpointNavigation
        }
    }
    
    public mutating func appendSourceViewController(_ sourceViewController: UIViewController)
    {
        switch self {
        case .settingNavigationRoot:
            break // has no source view controller property
            
        case .resettingNavigationRoot(var launchingContext):
            launchingContext.sourceViewController = sourceViewController
            self = .resettingNavigationRoot(launchingContext: launchingContext)
            
        case .registering:
            break // no need for animations
            
        case .registeringEndpointNavigation:
            break // no need for animations
        }
    }
}
