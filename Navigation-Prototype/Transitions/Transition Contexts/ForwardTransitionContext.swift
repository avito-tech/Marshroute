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
    let targetTransitionsHandlerBox: ForwardTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    let animationLaunchingContext: TransitionAnimationLaunchingContext
    
    // MARK: - Navigation
    
    /// Контекст описывает первоначальную настройку (или обновление) обработчика переходов, т.е
    /// проставление корневого контроллера в UINavigationController
    init(resettingWithViewController initialViewController: UIViewController,
        animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler,
        animator: NavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = initialViewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)
        
        self.storableParameters = nil
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Push,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: targetViewController),
            animator: animator)
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает последовательный переход внутри UINavigationController'а текущего модуля
    init(pushingViewController targetViewController: UIViewController,
        animator: NavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = .Pending
       
        self.storableParameters = nil
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Push,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: targetViewController),
            animator: animator)
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает переход на модальный контроллер, который нельзя! положить в UINavigationController:
    /// UISplitViewController, UITabBarViewController
    init(presentingModalMasterDetailViewController targetViewController: UIViewController,
        targetTransitionsHandler: ContainingTransitionsHandler,
        animator: NavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = .init(containingTransitionsHandler: targetTransitionsHandler)
        
        self.storableParameters = NavigationTransitionStorableParameters(
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Modal,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: targetViewController),
            animator: animator)
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает переход на модальный контроллер, который положен в UINavigationController
    init(presentingModalViewController targetViewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        targetTransitionsHandler: AnimatingTransitionsHandler,
        animator: NavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        assert(
            !(targetViewController is UISplitViewController) && !(targetViewController is UITabBarController),
            "use presentingModalMasterDetailViewController:targetTransitionsHandler:animator"
        )
        
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: targetTransitionsHandler)
        
        self.storableParameters = NavigationTransitionStorableParameters(
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Modal,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: navigationController),
            animator: animator)
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    // MARK: - Popover
    
    /// Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
    init(presentingViewController targetViewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromRect rect: CGRect,
        inView view: UIView,
        targetTransitionsHandler: AnimatingTransitionsHandler,
        animator: PopoverTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.targetViewController = targetViewController
        self.transitionId = transitionId
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: targetTransitionsHandler)
        
        self.storableParameters = PopoverTransitionStorableParameters(
            popoverController: popoverController,
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        let popoverAnimationLaunchingContext = PopoverAnimationLaunchingContext(
            transitionStyle: .PopoverFromView(sourceView: view, sourceRect: rect),
            animationSourceParameters: PopoverAnimationSourceParameters(popoverController: popoverController),
            animationTargetParameters: PopoverAnimationTargetParameters(viewController: targetViewController),
            animator: animator)
        
        self.animationLaunchingContext = .Popover(launchingContext: popoverAnimationLaunchingContext)
    }
    
    /// Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
    init(presentingViewController targetViewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromBarButtonItem buttonItem: UIBarButtonItem,
        targetTransitionsHandler: AnimatingTransitionsHandler,
        animator: PopoverTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: targetTransitionsHandler)

        self.storableParameters = PopoverTransitionStorableParameters(
            popoverController: popoverController,
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        let popoverAnimationLaunchingContext = PopoverAnimationLaunchingContext(
            transitionStyle: .PopoverFromBarButtonItem(buttonItem: buttonItem),
            animationSourceParameters: PopoverAnimationSourceParameters(popoverController: popoverController),
            animationTargetParameters: PopoverAnimationTargetParameters(viewController: targetViewController),            
            animator: animator)
        
        self.animationLaunchingContext = .Popover(launchingContext: popoverAnimationLaunchingContext)
    }
}

// MARK: - Convenience
extension ForwardTransitionContext {
    var needsTargetTransitionsHandler: Bool {
        let result = self.targetTransitionsHandlerBox.unbox() == nil
        return result
    }
    
    /// Контекст с обновленным обработчиком переходов
    init(context: ForwardTransitionContext, changingTargetAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler) {
        self.transitionId = context.transitionId
        self.targetViewController = context.targetViewController
        self.storableParameters = context.storableParameters
        self.animationLaunchingContext = context.animationLaunchingContext
        
        // меняем только обработчика переходов
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)
    }
}