import UIKit

/**
 *  Описание параметров анимации
 */
struct TransitionAnimationLaunchingContext {
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator

    /// параметры анимации перехода, получаемые из информации об исходной точке прямого или обратного перехода
    var animationSourceParameters: TransitionAnimationSourceParameters?
    
    /// параметры анимации перехода, получаемые из информации о конечной точке прямого или обратного перехода
    let animationTargetParameters: TransitionAnimationTargetParameters
}

/**
 *  Описание перехода от модуля к модулю. Передается из роутера в обработчик переходов, чтобы осуществить переход на другой модуль
 */
struct ForwardTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    let transitionId: TransitionId
    
    /// контроллер, на который нужно перейти
    let targetViewController: UIViewController
    
    /// обработчик переходов для модуля, на который нужно перейти
    /// (может отличаться от обработчика переходов, ответственного за выполнение текущего перехода)
    let targetTransitionsHandler: TransitionsHandler
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    let animationLaunchingContext: TransitionAnimationLaunchingContext
    
    /**
     Контекст описывает первоначальную настройку обработчика переходов (проставление корневого контроллера навигации)
     */
    init(resetingWithViewController initialViewController: UIViewController,
        transitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = initialViewController
        self.targetTransitionsHandler = transitionsHandler
        
        self.storableParameters = nil
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: .Push,
            animator: animator,
            animationSourceParameters: nil,
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: targetViewController)
        )
    }
    
    /**
     Контекст описывает последовательный переход внутри UINavigationController'а текущего модуля
     */
    init(pushingViewController targetViewController: UIViewController,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
       
        self.storableParameters = nil
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: .Push,
            animator: animator,
            animationSourceParameters: nil,
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: targetViewController)
        )
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
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        
        self.storableParameters = NavigationTransitionStorableParameters(
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: .Modal,
            animator: animator,
            animationSourceParameters: nil,
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: targetViewController)
        )
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
        
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        
        self.storableParameters = NavigationTransitionStorableParameters(
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: .Modal,
            animator: animator,
            animationSourceParameters: nil,
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: navigationController)
        )
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
        self.transitionId = transitionId
        self.targetTransitionsHandler = targetTransitionsHandler
        
        self.storableParameters = PopoverTransitionStorableParameters(
            popoverController: popoverController,
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: .PopoverFromView(sourceView: view, sourceRect: rect),
            animator: animator,
            animationSourceParameters: PopoverAnimationSourceParameters(popoverController: popoverController),
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: navigationController)
        )
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
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler

        self.storableParameters = PopoverTransitionStorableParameters(
            popoverController: popoverController,
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: .PopoverFromButtonItem(buttonItem: buttonItem),
            animator: animator,
            animationSourceParameters: PopoverAnimationSourceParameters(popoverController: popoverController),
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: targetViewController)
        )
    }
    
    init(context: ForwardTransitionContext, changingTargetTransitionsHandler transitionsHandler: TransitionsHandler) {
        self.transitionId = context.transitionId
        self.targetTransitionsHandler = transitionsHandler // меняем только обработчика переходов
        self.targetViewController = context.targetViewController
        self.storableParameters = context.storableParameters
        self.animationLaunchingContext = context.animationLaunchingContext
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
    /// undoTransitionWith(transitionId:)
    let transitionId: TransitionId
    
    /// контроллер роутера, вызвавшего переход.
    private (set) weak var sourceViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, вызвавшего переход
    private (set) weak var sourceTransitionsHandler: TransitionsHandler?
    
    /// контроллер, на который перешли
    private (set) weak var targetViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    private (set) weak var targetTransitionsHandler: TransitionsHandler?
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    let animationLaunchingContext: TransitionAnimationLaunchingContext
    
    init(forwardTransitionContext context: ForwardTransitionContext,
        sourceViewController: UIViewController,
        sourceTransitionsHandler: TransitionsHandler)
    {
        self.transitionId = context.transitionId
        
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = context.targetViewController
        self.targetTransitionsHandler = context.targetTransitionsHandler
        
        self.storableParameters = context.storableParameters

        self.animationLaunchingContext = context.animationLaunchingContext
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
    /// undoTransitionWith(transitionId:)
    let transitionId: TransitionId
    
    /// контроллер роутера, вызвавшего переход.
    let sourceViewController: UIViewController
    
    /// обработчик переходов для роутера модуля, с контоллера которого перешли
    let sourceTransitionsHandler: TransitionsHandler
    
    /// контроллер, на который перешли
    let targetViewController: UIViewController
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    let targetTransitionsHandler: TransitionsHandler
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    let animationLaunchingContext: TransitionAnimationLaunchingContext
    
    init?(completedTransition context: CompletedTransitionContext?)
    {
        guard let context = context
            else { return nil }
        
        guard let sourceViewController = context.sourceViewController
            else { return nil }
        guard let sourceTransitionsHandler = context.sourceTransitionsHandler
            else { return nil }
        
        guard let targetViewController = context.targetViewController
            else { return nil }
        guard let targetTransitionsHandler = context.targetTransitionsHandler
            else { return nil }
        
        self.transitionId = context.transitionId
        
        self.sourceViewController = sourceViewController
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = targetViewController
        self.targetTransitionsHandler = targetTransitionsHandler
        
        self.storableParameters = context.storableParameters
        
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            transitionStyle: context.animationLaunchingContext.transitionStyle,
            animator: context.animationLaunchingContext.animator,
            animationSourceParameters: context.animationLaunchingContext.animationSourceParameters,
            animationTargetParameters: TransitionAnimationTargetParameters(viewController: sourceViewController)
        )
    }
}