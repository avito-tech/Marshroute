import UIKit

/**
 *  Передается из роутера в обработчик переходов, чтобы осуществить переход на другой модуль
 */
struct ForwardTransitionContext {
    /// контроллер, на который нужно перейти
    let targetViewController: UIViewController
    
    // TODO: aaa переделать на strong, не optional
    /// обработчик переходов для модуля, на который нужно перейти
    /// (может отличаться от обработчика переходов, ответственного за выполнение текущего перехода)
    let targetTransitionsHandler: TransitionsHandler?
    
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// параметры анимации перехода, присущие конкретному стилю перехода, и описывающие куда идет переход
    let animationTargetParameters: TransitionAnimationTargetParameters?
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator
    
    init(pushingViewController targetViewController: UIViewController,
        targetTransitionsHandler: TransitionsHandler?,
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .Push
            self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: targetViewController)
            self.storableParameters = nil
            self.animator = animator
    }
    
    init(presentingModalViewController targetViewController: UIViewController,
        targetTransitionsHandler: TransitionsHandler?,
        parentTransitionsHandler: TransitionsHandler, // например, SplitViewTransitionsHandler
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .Modal
            self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: targetViewController)
            self.storableParameters = NavigationTransitionStorableParameters(parentTransitionsHandler: parentTransitionsHandler)
            self.animator = animator
    }
    
    init(presentingModalViewController targetViewController: UIViewController,
        wrappedInNavigationController navigationController: UINavigationController,
        targetTransitionsHandler: TransitionsHandler?,
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .Modal
            self.animationTargetParameters = TransitionAnimationTargetParameters(viewController: navigationController)
            self.storableParameters = nil
            self.animator = animator
    }
    
    init(presentingViewController targetViewController: UIViewController,
        inPopoverController popoverController: UIPopoverController,
        fromRect rect: CGRect,
        inView view: UIView,
        targetTransitionsHandler: TransitionsHandler?,
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .PopoverFromView(sourceView: view, sourceRect: rect)
            self.animationTargetParameters = nil
            self.storableParameters = PopoverTransitionStorableParameters(popoverController: popoverController)
            self.animator = animator
    }
    
    init(presentingViewController targetViewController: UIViewController,
        wrappedInNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromRect rect: CGRect,
        inView view: UIView,
        targetTransitionsHandler: TransitionsHandler?,
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .PopoverFromView(sourceView: view, sourceRect: rect)
            self.animationTargetParameters = nil
            self.storableParameters = PopoverTransitionStorableParameters(popoverController: popoverController)
            self.animator = animator
    }
    
    init(presentingViewController targetViewController: UIViewController,
        inPopoverController popoverController: UIPopoverController,
        fromBarButtonItem buttonItem: UIBarButtonItem,
        targetTransitionsHandler: TransitionsHandler?,
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .PopoverFromButtonItem(buttonItem: buttonItem)
            self.animationTargetParameters = nil
            self.storableParameters = PopoverTransitionStorableParameters(popoverController: popoverController)
            self.animator = animator
    }
    
    init(presentingViewController targetViewController: UIViewController,
        wrappedInNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromBarButtonItem buttonItem: UIBarButtonItem,
        targetTransitionsHandler: TransitionsHandler?,
        animator: TransitionsAnimator) {
            self.targetViewController = targetViewController
            self.targetTransitionsHandler = targetTransitionsHandler
            self.transitionStyle = .PopoverFromButtonItem(buttonItem: buttonItem)
            self.animationTargetParameters = nil
            self.storableParameters = PopoverTransitionStorableParameters(popoverController: popoverController)
            self.animator = animator
    }
}

/**
 *  Передается из роутера в обработчик переходов, чтобы осуществить обратный переход на модуль роутера
 */
struct BackwardTransitionContext {
    private (set) var targetViewController: UIViewController
    
    init(targetViewController: UIViewController) {
        self.targetViewController = targetViewController
    }
}

/**
 *  Описание одного из совершенных обработчиком переходов.
 *  Хранится в обработчике переходов, чтобы иметь возможность выполнять обратные переходы.
 *  Слабые ссылки на показанный контроллер и его обработчик переходов позволяют пользоваться кнопкой '< Back' и т.д.
 */
struct CompletedTransitionContext {
    /// контроллер, c которого перешли
    private (set) weak var sourceViewController: UIViewController?

    /// контроллер, на который перешли
    private (set) weak var targetViewController: UIViewController?
    
    /// контроллер переходов для роутера модуля, на контроллер которого перешли
    private (set) weak var targetTransitionsHandler: TransitionsHandler?
    
    /// стиль перехода
    let transitionStyle: TransitionStyle
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    let storableParameters: TransitionStorableParameters?
    
    /// объект, выполняющий анимацию перехода
    let animator: TransitionsAnimator
    
    init(forwardTransitionContext context: ForwardTransitionContext,
        sourceViewController: UIViewController) {
            self.sourceViewController = sourceViewController
            self.targetViewController = context.targetViewController
            self.targetTransitionsHandler = context.targetTransitionsHandler
            self.transitionStyle = context.transitionStyle
            self.storableParameters = context.storableParameters
            self.animator = context.animator
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
    /// контроллер, с которого перешли
    let sourceViewController: UIViewController
    
    /// контроллер, на который перешли
    let targetViewController: UIViewController
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    // TODO: aaa сделать не optional
    let transitionsHandler: TransitionsHandler?
    
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
    
    init?(context: CompletedTransitionContext?) {
        guard let context = context
            else { return nil }
        guard let targetViewController = context.targetViewController
            else { return nil }
        guard let sourceViewController = context.sourceViewController
            else { return nil }
        // TODO: aaa вернуть проверку
        //guard let transitionsHandler = context.targetTransitionsHandler
            //else { return nil }
        
        self.targetViewController = targetViewController
        self.sourceViewController = sourceViewController
        // TODO: aaa вернуть утверждение (и проверку сверху)
        // self.transitionsHandler = transitionsHandler
        self.transitionsHandler = context.targetTransitionsHandler
        self.transitionStyle = context.transitionStyle
        self.storableParameters = context.storableParameters
        self.animator = context.animator
    }
}