/// Варианты хранения обработчика переходов показанного модуля
public enum CompletedTransitionTargetTransitionsHandlerBox {
    case Animating(WeakBox<AnimatingTransitionsHandler>)
    case Containing(WeakBox<ContainingTransitionsHandler>)

    // MARK: - Init
    public init?(presentationTransitionTargetTransitionsHandlerBox: PresentationTransitionTargetTransitionsHandlerBox)
    {
        switch presentationTransitionTargetTransitionsHandlerBox {
        case .Animating(let strongBox):
            let animatingTransitionsHandler = strongBox.unbox()
            self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .Containing(let strongBox):
            let containingTransitionsHandler = strongBox.unbox()
            self = .init(containingTransitionsHandler: containingTransitionsHandler)

        default:
            return nil
        }
    }
    
    public init?(resettingTransitionTargetTransitionsHandlerBox: ResettingTransitionTargetTransitionsHandlerBox)
    {
        switch resettingTransitionTargetTransitionsHandlerBox {
        case .Animating(let stronBox):
            self = .init(animatingTransitionsHandler: stronBox.unbox())
        }
    }

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .Animating(WeakBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .Containing(WeakBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }

    // MARK: - helpers
    public func unbox() -> TransitionsHandler?
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()

        case .Containing(let weakBox):
            return weakBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
        
        default:
            return nil
        }
    }
    
    public func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .Containing(let weakBox):
            return weakBox.unbox()
        
        default:
            return nil
        }
    }
}