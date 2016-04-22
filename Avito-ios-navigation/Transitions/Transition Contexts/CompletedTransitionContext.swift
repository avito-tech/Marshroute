import UIKit

/// Описание одного из совершенных обработчиком переходов.
/// Хранится в истории, чтобы иметь возможность выполнять обратные переходы.
/// Все важные ссылки хранятся слабо, чтобы не нарушать UIKit'овый цикл управления памятью.
/// т.е. чтобы спокойно пользоваться кнопкой `< Back`, например
public struct CompletedTransitionContext {
    /// идентификатор перехода
    /// для точной отмены нужного перехода и возвращения на предыдущий экран через
    /// ```swift
    /// undoTransitionWith(transitionId:)
    public let transitionId: TransitionId
    
    /// обработчик переходов для роутера модуля, вызвавшего переход
    public private(set) weak var sourceTransitionsHandler: AnimatingTransitionsHandler?
    
    /// контроллер, на который перешли
    public private(set) weak var targetViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    public let targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    public let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации прямого перехода
    public let presentationAnimationLaunchingContextBox: PresentationAnimationLaunchingContextBox
    
    init?(forwardTransitionContext context: ForwardTransitionContext,
        sourceTransitionsHandler: AnimatingTransitionsHandler)
    {
        guard !context.needsAnimatingTargetTransitionHandler else {
            assert(false, "заполните `targetTransitionsHandlerBox` анимирующим обработчиком переходов раньше - до выполнения самого перехода")
            return nil
        }
        
        guard let targetTransitionsHandlerBox = CompletedTransitionTargetTransitionsHandlerBox(
            forwardTransitionTargetTransitionsHandlerBox: context.targetTransitionsHandlerBox
        )
            else { return nil }
        
        self.transitionId = context.transitionId
        
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = context.targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        
        self.storableParameters = context.storableParameters

        self.presentationAnimationLaunchingContextBox = context.presentationAnimationLaunchingContextBox
    }
    
    /// Все важные ссылки хранятся слабо, чтобы не нарушать UIKit'овый цикл управления памятью.
    /// т.е. чтобы спокойно пользоваться кнопкой `< Back`, например, и targetViewController освободится.
    /// запись об таком переходе очищается лениво
    var isZombie: Bool {
        return targetViewController == nil
    }
}

// MARK: - convenience
extension CompletedTransitionContext {
    init(transitionId: TransitionId,
        sourceTransitionsHandler: AnimatingTransitionsHandler?,
        targetViewController: UIViewController?,
        targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox,
        storableParameters: TransitionStorableParameters?,
        presentationAnimationLaunchingContextBox: PresentationAnimationLaunchingContextBox)
    {
        self.transitionId = transitionId
        self.sourceTransitionsHandler = sourceTransitionsHandler
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        self.storableParameters = storableParameters
        self.presentationAnimationLaunchingContextBox = presentationAnimationLaunchingContextBox
    }
}