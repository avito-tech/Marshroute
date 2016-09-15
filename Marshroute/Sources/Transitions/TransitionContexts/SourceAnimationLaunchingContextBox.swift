import UIKit

/// Описание параметров запуска анимаций перехода, хранимого в истории переходов
public enum SourceAnimationLaunchingContextBox {
    case presentation(launchingContextBox: PresentationAnimationLaunchingContextBox)
    case resetting(launchingContextBox: ResettingAnimationLaunchingContextBox)
    
    public func unboxPresentationAnimationLaunchingContextBox() -> PresentationAnimationLaunchingContextBox?
    {
        switch self {
        case .presentation(let launchingContextBox):
            return launchingContextBox
            
        case .resetting:
            return nil
        }
    }
}
