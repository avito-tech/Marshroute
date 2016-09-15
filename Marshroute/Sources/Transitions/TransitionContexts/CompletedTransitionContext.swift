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
    public fileprivate(set) weak var sourceTransitionsHandler: AnimatingTransitionsHandler?
    
    /// контроллер, на который перешли
    public fileprivate(set) weak var targetViewController: UIViewController?
    
    /// обработчик переходов для роутера модуля, на контроллер которого перешли
    public let targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox
    
    /// параметры перехода, на которые нужно держать сильную ссылку (например, обработчик переходов SplitViewController'а)
    public let storableParameters: TransitionStorableParameters?
    
    /// параметры запуска анимации перехода
    public let sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox
    
    /// Все важные ссылки хранятся слабо, чтобы не нарушать UIKit'овый цикл управления памятью.
    /// т.е. чтобы спокойно пользоваться кнопкой `< Back`, например, и targetViewController освободится.
    /// запись об таком переходе очищается лениво
    public var isZombie: Bool {
        return targetViewController == nil
    }
    
    // MARK: - Init
    public init?(presentationTransitionContext context: PresentationTransitionContext,
        sourceTransitionsHandler: AnimatingTransitionsHandler)
    {
        guard !context.needsAnimatingTargetTransitionHandler else {
            assert(false, "заполните `targetTransitionsHandlerBox` анимирующим обработчиком переходов раньше - до выполнения самого перехода")
            return nil
        }
        
        let transitionsHandlerBox = CompletedTransitionTargetTransitionsHandlerBox(
            presentationTransitionTargetTransitionsHandlerBox: context.targetTransitionsHandlerBox
        )
        
        guard let targetTransitionsHandlerBox = transitionsHandlerBox
            else { return nil }
        
        self.transitionId = context.transitionId
        
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = context.targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        
        self.storableParameters = context.storableParameters

        self.sourceAnimationLaunchingContextBox = .presentation(
            launchingContextBox: context.presentationAnimationLaunchingContextBox
        )
    }
    
    public init?(resettingTransitionContext context: ResettingTransitionContext,
        sourceTransitionsHandler: AnimatingTransitionsHandler)
    {
        let transitionsHandlerBox = CompletedTransitionTargetTransitionsHandlerBox(
            resettingTransitionTargetTransitionsHandlerBox: context.targetTransitionsHandlerBox
        )
        
        guard let targetTransitionsHandlerBox = transitionsHandlerBox
            else { return nil }
        
        self.transitionId = context.transitionId
        
        self.sourceTransitionsHandler = sourceTransitionsHandler
        
        self.targetViewController = context.targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        
        self.storableParameters = context.storableParameters
        
        self.sourceAnimationLaunchingContextBox = .resetting(
            launchingContextBox: context.resettingAnimationLaunchingContextBox
        )
    }
    
    public init(
        transitionId: TransitionId,
        sourceTransitionsHandler: AnimatingTransitionsHandler?,
        targetViewController: UIViewController?,
        targetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox,
        storableParameters: TransitionStorableParameters?,
        sourceAnimationLaunchingContextBox: SourceAnimationLaunchingContextBox)
    {
        self.transitionId = transitionId
        self.sourceTransitionsHandler = sourceTransitionsHandler
        self.targetViewController = targetViewController
        self.targetTransitionsHandlerBox = targetTransitionsHandlerBox
        self.storableParameters = storableParameters
        self.sourceAnimationLaunchingContextBox = sourceAnimationLaunchingContextBox
    }
}
