import UIKit

/// Описание параметров запуска анимаций перехода, хранимого в истории переходов
public enum CompletedTransitionContextSourceAnimationLaunchingContextBox {
    case Presentation(launchingContextBox: PresentationAnimationLaunchingContextBox)
    case Resetting(launchingContextBox: ResettingAnimationLaunchingContextBox)
    
    public func unboxPresentationAnimationLaunchingContextBox() -> PresentationAnimationLaunchingContextBox?
    {
        switch self {
        case .Presentation(let launchingContextBox):
            return launchingContextBox
            
        case .Resetting(_):
            return nil
        }
    }
}