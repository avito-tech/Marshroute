import UIKit

/// Описание одного из совершенных обработчиком переходов, восстановленное из истории
/// Заведомо известно, что живы все участники изначального перехода.
/// Отличается от CompletedTransitionContext тем, что все поля в нем уже не `optional` и не `weak`
public struct RestoredTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    public let transitionId: TransitionId
    
    /// обработчик переходов для роутера модуля, с контоллера которого перешли
    public let sourceTransitionsHandler: AnimatingTransitionsHandler
    
    /// контроллер, на который перешли
    public let targetViewController: UIViewController
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    public let targetTransitionsHandlerBox: RestoredTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    public let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    public let sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox
}

// MARK: - Init
public extension RestoredTransitionContext {
    init?(completedTransition context: CompletedTransitionContext?)
    {
        guard let context = context
            else { return nil }
        
        guard let sourceTransitionsHandler = context.sourceTransitionsHandler
            else { return nil }
        
        guard let targetViewController = context.targetViewController
            else { return nil }
        
        guard let targetTransitionsHandlerBox = RestoredTransitionTargetTransitionsHandlerBox(
            completedTransitionTargetTransitionsHandlerBox: context.targetTransitionsHandlerBox)
            else { return nil }
        
        self.transitionId = context.transitionId
        
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        
        self.storableParameters = context.storableParameters
        
        self.sourceAnimationLaunchingContextBox = context.sourceAnimationLaunchingContextBox
    }
}

// MARK: - Equatable
extension RestoredTransitionContext: Equatable {}

public func ==(lhs: RestoredTransitionContext, rhs: RestoredTransitionContext) -> Bool {
    return lhs.transitionId == rhs.transitionId
}
