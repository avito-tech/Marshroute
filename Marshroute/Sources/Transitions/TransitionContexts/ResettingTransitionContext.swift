import UIKit

/// Описание reset-перехода (смотри init'ы для более полного описания)
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
    public private(set) var targetTransitionsHandlerBox: ResettingTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    public let storableParameters: TransitionStorableParameters?

    /// параметры запуска анимации прямого перехода
    public var resettingAnimationLaunchingContextBox: ResettingAnimationLaunchingContextBox
}

// MARK: - Init
public extension ResettingTransitionContext {
    /// Контекст описывает первоначальную настройку обработчика переходов
    /// при первом проставлении корневого контроллера в UINavigationController
    init(
        settingRootViewController rootViewController: UIViewController,
        forNavigationController navigationController: UINavigationController,
        navigationTransitionsHandler transitionsHandler: NavigationTransitionsHandler,
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
    init(
        resettingRootViewController rootViewController: UIViewController,
        navigationTransitionsHandler: NavigationTransitionsHandler,
        animator: ResetNavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = rootViewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: navigationTransitionsHandler)

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
    /// например, c MFMailComposeViewController'а, UIImagePickerController'а.
    /// "Конечный" здесь означает, что дальше навигация управляется чисто UIKIt'овым флоу и Marshroute там не при делах
    init(
        registeringEndpointNavigationController navigationController: UINavigationController,
        navigationTransitionsHandler: NavigationTransitionsHandler,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = navigationController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: navigationTransitionsHandler)
        
        self.storableParameters = nil
        
        self.resettingAnimationLaunchingContextBox = .registeringEndpointNavigation
    }
    
    /// Контекст описывает регистрацию обычного UIViewController'а, не обернутого в UINavigationController показывамого модально или поповером
    init(
        registeringViewController viewController: UIViewController,
        animatingTransitionsHandler: AnimatingTransitionsHandler,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = viewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: animatingTransitionsHandler)
        
        self.storableParameters = nil
        
        self.resettingAnimationLaunchingContextBox = .registering
    }
    
}
