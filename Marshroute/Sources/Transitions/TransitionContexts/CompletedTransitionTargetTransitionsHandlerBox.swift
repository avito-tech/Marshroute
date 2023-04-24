/// Варианты хранения обработчика переходов показанного модуля
public enum CompletedTransitionTargetTransitionsHandlerBox {
    case animating(WeakAnimatingTransitionsHandlerBox)
    case containing(WeakContainingTransitionsHandlerBox)

    // MARK: - Init
    public init?(presentationTransitionTargetTransitionsHandlerBox: PresentationTransitionTargetTransitionsHandlerBox)
    {
        switch presentationTransitionTargetTransitionsHandlerBox {
        case .animating(let animatingTransitionsHandler):
            self.init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .containing(let containingTransitionsHandler):
            self.init(containingTransitionsHandler: containingTransitionsHandler)
            
        default:
            return nil
        }
    }
    
    public init?(resettingTransitionTargetTransitionsHandlerBox: ResettingTransitionTargetTransitionsHandlerBox)
    {
        switch resettingTransitionTargetTransitionsHandlerBox {
        case .animating(let animatingTransitionsHandler):
            self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
        }
    }

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .animating(WeakAnimatingTransitionsHandlerBox(animatingTransitionsHandler))
    }

    public init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .containing(WeakContainingTransitionsHandlerBox(containingTransitionsHandler))
    }
}
