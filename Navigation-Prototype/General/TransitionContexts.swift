import UIKit

/**
 *  Передается из роутера в обработчик переходов, чтобы осуществить переход на другой модуль
 */
struct ForwardTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransition(toId:)
    let transitionId: TransitionId
    
    /// контроллер, на который нужно перейти
    let targetViewController: UIViewController
    
    /// обработчик переходов для модуля, на который нужно перейти
    /// (может отличаться от обработчика переходов, ответственного за выполнение текущего перехода)
    let targetTransitionsHandler: TransitionsHandler
    
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// параметры анимации перехода, присущие конкретному стилю перехода, и описывающие куда идет переход
    let animationTargetParameters: TransitionAnimationTargetParameters?
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator
    
    /**
     Контекст описывает первоначальную настройку обработчика переходов (проставление корневого контроллера навигации)
     */
    init(resetingWithViewController initialViewController: UIViewController,
        transitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.targetViewController = initialViewController
        self.targetTransitionsHandler = transitionsHandler
        self.transitionStyle = .Push
        self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: targetViewController)
        self.storableParameters = nil
        self.animator = animator
        self.transitionId = transitionId
    }
    
    /**
     Контекст описывает последовательный переход внутри UINavigationController'а текущего модуля
     */
    init(pushingViewController targetViewController: UIViewController,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        self.transitionStyle = .Push
        self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: targetViewController)
        self.storableParameters = nil
        self.animator = animator
        self.transitionId = transitionId
    }
    
    /**
     Контекст описывает переход на модальный контроллер, который нельзя! положить в UINavigationController:
     (UISplitViewController, UITabBarViewController)
     */
    init(presentingModalMasterDetailViewController targetViewController: UIViewController,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        self.transitionStyle = .Modal
        self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: targetViewController)
        self.storableParameters = NavigationTransitionStorableParameters(parentTransitionsHandler: targetTransitionsHandler)
        self.animator = animator
        self.transitionId = transitionId
    }
    
    /**
     Контекст описывает переход на модальный контроллер, который положен в UINavigationController
     */
    init(presentingModalViewController targetViewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        assert(
            !(targetViewController is UISplitViewController) && !(targetViewController is UITabBarController),
            "use presentingModalMasterDetailViewController:targetTransitionsHandler:animator"
        )
        
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        self.transitionStyle = .Modal
        self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: navigationController)
        self.storableParameters = nil
        self.animator = animator
        self.transitionId = transitionId
    }
    
    /**
     Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
     */
    init(presentingViewController targetViewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromRect rect: CGRect,
        inView view: UIView,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        self.transitionStyle = .PopoverFromView(sourceView: view, sourceRect: rect)
        self.animationTargetParameters = nil
        self.storableParameters = PopoverTransitionStorableParameters(popoverController: popoverController)
        self.animator = animator
        self.transitionId = transitionId
    }
    
    /**
     Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
     */
    init(presentingViewController targetViewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromBarButtonItem buttonItem: UIBarButtonItem,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        self.transitionStyle = .PopoverFromButtonItem(buttonItem: buttonItem)
        self.animationTargetParameters = nil
        self.storableParameters = PopoverTransitionStorableParameters(popoverController: popoverController)
        self.animator = animator
        self.transitionId = transitionId
    }
}

/**
 *  Описание одного из совершенных обработчиком переходов.
 *  Хранится в обработчике переходов, чтобы иметь возможность выполнять обратные переходы.
 *  Слабые ссылки на показанный контроллер и его обработчик переходов позволяют пользоваться кнопкой '< Back' и т.д.
 */
struct CompletedTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransition(toId:)
    let transitionId: TransitionId
    
    /// контроллер роутера, вызвавшего переход.
    /// удобно использовать роутером модуля контейнера
    /// для отмены всех переходов и возвращения на главный экран контейнера через
    /// ```swift
    /// undoTransitions(tilContext:)
    private (set) weak var sourceViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, вызвавшего переход
    private (set) weak var sourceTransitionsHandler: TransitionsHandler?
    
    /// контроллер, на который перешли
    private (set) weak var targetViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    private (set) weak var targetTransitionsHandler: TransitionsHandler?
    
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator
    
    init(forwardTransitionContext context: ForwardTransitionContext,
        sourceViewController: UIViewController,
        sourceTransitionsHandler: TransitionsHandler,
        transitionId: String)
    {
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = context.targetViewController
        self.targetTransitionsHandler = context.targetTransitionsHandler
        
        self.transitionStyle = context.transitionStyle
        self.storableParameters = context.storableParameters
        self.animator = context.animator
        
        self.transitionId = transitionId
    }
    
    var isZombie: Bool {
        return targetViewController == nil
    }
}

/**
 *  Описание одного из совершенных обработчиком переходов.
 *  При этом заведомо известно, что контроллер, на модуль которого перешли, еще жив.
 *  Отличается от CompletedTransitionContext тем, что все поля в нем уже не optional (для удобства)
 */
struct RestoredTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransition(toId:)
    let transitionId: TransitionId
    
    /// контроллер роутера, вызвавшего переход.
    /// удобно использовать роутером модуля контейнера
    /// для отмены всех переходов и возвращения на главный экран контейнера через
    /// ```swift
    /// undoTransitions(tilContext:)
    let sourceViewController: UIViewController
    
    /// обработчик переходов для роутера модуля, с контоллера которого перешли
    let sourceTransitionsHandler: TransitionsHandler
    
    /// контроллер, на который перешли
    let targetViewController: UIViewController
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    let targetTransitionsHandler: TransitionsHandler
    
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// параметры анимации обратного перехода, описывающие куда идет переход
    var animationTargetParameters: TransitionAnimationTargetParameters {
        return TransitionAnimationTargetParameters(viewController: sourceViewController)
    }
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator
    
    init?(completedTransition context: CompletedTransitionContext?)
    {
        guard let context = context
            else { return nil }
        guard let sourceViewController = context.sourceViewController
            else { return nil }
        guard let sourceTransitionsHandler = context.targetTransitionsHandler
            else { return nil }
        guard let targetTransitionsHandler = context.targetTransitionsHandler
            else { return nil }
        guard let targetViewController = context.targetViewController
            else { return nil }
        
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        
        self.transitionStyle = context.transitionStyle
        self.storableParameters = context.storableParameters
        self.animator = context.animator
        
        self.transitionId = context.transitionId
    }
}