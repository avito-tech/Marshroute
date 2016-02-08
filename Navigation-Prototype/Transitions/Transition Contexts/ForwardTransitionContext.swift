import UIKit

/// Описание перехода `вперед` на следующий модуль
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
    

    /// Контекст описывает первоначальную настройку (или обновление) обработчика переходов, т.е
    /// проставление корневого контроллера в UINavigationController
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
    
    /// Контекст описывает последовательный переход внутри UINavigationController'а текущего модуля
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
    
    /// Контекст описывает переход на модальный контроллер, который нельзя! положить в UINavigationController:
    /// UISplitViewController, UITabBarViewController
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
    
    /// Контекст описывает переход на модальный контроллер, который положен в UINavigationController
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
    
    /// Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
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
    
    /// Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
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
    
    /// Контекст с обновленным обработчиком переходов
    init(context: ForwardTransitionContext, changingTargetTransitionsHandler transitionsHandler: TransitionsHandler) {
        self.transitionId = context.transitionId
        self.targetTransitionsHandler = transitionsHandler // меняем только обработчика переходов
        self.targetViewController = context.targetViewController
        self.storableParameters = context.storableParameters
        self.animationLaunchingContext = context.animationLaunchingContext
    }
}