import UIKit

/// Описание reset-перехода
public struct ResettingTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    public let transitionId: TransitionId
    
    /// контроллер, на который нужно перейти
    public let targetViewController: UIViewController
    
    /// обработчик переходов для модуля, на который нужно перейти
    /// (может отличаться от обработчика переходов, ответственного за выполнение текущего перехода)
    public fileprivate(set) var targetTransitionsHandlerBox: ResettingTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    public let storableParameters: TransitionStorableParameters?

    /// параметры запуска анимации прямого перехода
    public var resettingAnimationLaunchingContextBox: ResettingAnimationLaunchingContextBox
}

// MARK: - Init
public extension ResettingTransitionContext {
    /// Контекст описывает первоначальную настройку обработчика переходов
    /// при первом проставления корневого контроллера в UINavigationController
    init(settingRootViewController rootViewController: UIViewController,
        forNavigationController navigationController: UINavigationController,
        animatingTransitionsHandler transitionsHandler: NavigationTransitionsHandlerImpl,
        animator: SetNavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = rootViewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)
        
        self.storableParameters = nil
        
        let animationLaunchingContext = SettingAnimationLaunchingContext(
            rootViewController: rootViewController,
            navigationController: navigationController,
            animator: animator
        )
        
        self.resettingAnimationLaunchingContextBox = .settingNavigationRoot(
            launchingContext: animationLaunchingContext
        )
    }
    
    /// Контекст описывает сброс истории обработчика переходов
    /// для проставления нового корневого контроллера в UINavigationController
    init(resettingRootViewController rootViewController: UIViewController,
        animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler,
        animator: ResetNavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = rootViewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)

        self.storableParameters = nil
        
        let animationLaunchingContext = ResettingAnimationLaunchingContext(
            rootViewController: rootViewController,
            animator: animator
        )
        
        self.resettingAnimationLaunchingContextBox = .resettingNavigationRoot(
            launchingContext: animationLaunchingContext
        )
    }
    
    /// Контекст описывает регистрацию конечного UINavigationController'а,
    /// например, c MFMailComposeViewController'а, UIImagePickerController'а
    init(registeringEndpointNavigationController navigationController: UINavigationController,
        animatingTransitionsHandler transitionsHandler: NavigationTransitionsHandlerImpl,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = navigationController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)
        
        self.storableParameters = nil
        
        self.resettingAnimationLaunchingContextBox = .registeringEndpointNavigation
    }
    
    /// Контекст описывает регистрацию конечного UINavigationController'а,
    /// например, c MFMailComposeViewController'а, UIImagePickerController'а
    init(registeringViewController viewController: UIViewController,
        animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = viewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)
        
        self.storableParameters = nil
        
        self.resettingAnimationLaunchingContextBox = .registering
    }
    
}
