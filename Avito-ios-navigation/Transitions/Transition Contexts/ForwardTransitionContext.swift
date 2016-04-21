import UIKit

/// Описание перехода `вперед` на следующий модуль
public struct ForwardTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    public let transitionId: TransitionId
    
    /// контроллер, на который нужно перейти
    public let targetViewController: UIViewController
    
    /// обработчик переходов для модуля, на который нужно перейти
    /// (может отличаться от обработчика переходов, ответственного за выполнение текущего перехода)
    public private(set) var targetTransitionsHandlerBox: ForwardTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    public let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    public let animationLaunchingContext: TransitionAnimationLaunchingContext
    
    // MARK: - Navigation
    
    /// Контекст описывает первоначальную настройку (или обновление) обработчика переходов.
    /// В случае, когда initialViewController - обычный `UIViewController`,
    /// с показом UINavigationController'
    /// проставление корневого контроллера в UINavigationController
    public init(resettingWithViewController initialViewController: UIViewController,
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
            animator: animator
        )
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает последовательный переход внутри UINavigationController'а текущего модуля
    public init(pushingViewController targetViewController: UIViewController,
        animator: NavigationTransitionsAnimator,
        transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = .PendingAnimating
       
        self.storableParameters = nil
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Push,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: targetViewController),
            animator: animator
        )
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает переход на модальный контроллер, который нельзя! положить в UINavigationController:
    /// UISplitViewController, UITabBarViewController
    public init(presentingModalMasterDetailViewController targetViewController: UIViewController,
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
            animator: animator
        )
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает переход на модальный контроллер, который положен в UINavigationController
    public init(presentingModalViewController targetViewController: UIViewController,
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
            animator: animator
        )
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает переход на модальный UINavigationController 
    /// использовать для MFMailComposeViewController, UIImagePickerViewController
    public init(presentingModalNavigationController navigationController: UINavigationController,
        targetTransitionsHandler: AnimatingTransitionsHandler,
        animator: NavigationTransitionsAnimator,
        transitionId: TransitionId)
    {        
        self.transitionId = transitionId
        self.targetViewController = navigationController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: targetTransitionsHandler)
        
        self.storableParameters = NavigationTransitionStorableParameters(
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Modal,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: navigationController),
            animator: animator
        )
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    /// Контекст описывает переход на модальный UINavigationController
    /// использовать для MFMailComposeViewController, UIImagePickerViewController
    public init(presentingModalViewController viewController: UIViewController,
                targetTransitionsHandler: AnimatingTransitionsHandler,
                animator: NavigationTransitionsAnimator,
                transitionId: TransitionId)
    {
        self.transitionId = transitionId
        self.targetViewController = viewController
        self.targetTransitionsHandlerBox = .init(animatingTransitionsHandler: targetTransitionsHandler)
        
        self.storableParameters = NavigationTransitionStorableParameters(
            presentedTransitionsHandler: targetTransitionsHandler
        )
        
        let navigationAnimationLaunchingContext = NavigationAnimationLaunchingContext(
            transitionStyle: .Modal,
            animationTargetParameters: NavigationAnimationTargetParameters(viewController: viewController),
            animator: animator
        )
        
        self.animationLaunchingContext = .Navigation(launchingContext: navigationAnimationLaunchingContext)
    }
    
    // MARK: - Popover
    
    /// Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
    public init(presentingViewController targetViewController: UIViewController,
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
            animator: animator
        )
        
        self.animationLaunchingContext = .Popover(launchingContext: popoverAnimationLaunchingContext)
    }
    
    /// Контекст описывает вызов поповера, содержащего контроллер, который положен в UINavigationController
    public init(presentingViewController targetViewController: UIViewController,
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
            animator: animator
        )
        
        self.animationLaunchingContext = .Popover(launchingContext: popoverAnimationLaunchingContext)
    }
}

// MARK: - Convenience
extension ForwardTransitionContext {
    var needsAnimatingTargetTransitionHandler: Bool {
        let result = self.targetTransitionsHandlerBox.needsAnimatingTargetTransitionHandler
        return result
    }
    
    /// Проставляем непроставленного ранее обработчика переходов
    mutating func setAnimatingTargetTransitionsHandler(transitionsHandler: AnimatingTransitionsHandler)
    {
        assert(needsAnimatingTargetTransitionHandler)
        targetTransitionsHandlerBox = .init(animatingTransitionsHandler: transitionsHandler)
    }
}