import UIKit

/// Описание одного из совершенных обработчиком переходов, восстановленное из истории
/// Заведомо известно, что живы все участники изначального перехода.
/// Отличается от CompletedTransitionContext тем, что все поля в нем уже не `optional` и не `weak`
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
        
        // обновляем информацию о конечной точке анимации
        self.animationLaunchingContext = TransitionAnimationLaunchingContext(
            context: context.animationLaunchingContext,
            targetViewController: sourceViewController
        )
    }
}

// MARK: - Equatable
extension RestoredTransitionContext: Equatable {}

func ==(lhs: RestoredTransitionContext, rhs: RestoredTransitionContext) -> Bool {
    return lhs.transitionId == rhs.transitionId
}