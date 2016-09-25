/// Варианты хранения обработчика переходов показанного модуля
public enum CompletedTransitionTargetTransitionsHandlerBox {
    case animating(weakBox: WeakBox<AnimatingTransitionsHandler>)
    case containing(weakBox: WeakBox<ContainingTransitionsHandler>)

    // MARK: - Init
    public init?(presentationTransitionTargetTransitionsHandlerBox: PresentationTransitionTargetTransitionsHandlerBox)
    {
        switch presentationTransitionTargetTransitionsHandlerBox {
        case .animating(let strongBox):
            let animatingTransitionsHandler = strongBox.unbox()
            self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .containing(let strongBox):
            let containingTransitionsHandler = strongBox.unbox()
            self = .init(containingTransitionsHandler: containingTransitionsHandler)

        default:
            return nil
        }
    }
    
    public init?(resettingTransitionTargetTransitionsHandlerBox: ResettingTransitionTargetTransitionsHandlerBox)
    {
        switch resettingTransitionTargetTransitionsHandlerBox {
        case .animating(let stronBox):
            self = .init(animatingTransitionsHandler: stronBox.unbox())
        }
    }

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .animating(weakBox: WeakBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .containing(weakBox: WeakBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }

    // MARK: - helpers
    public func unbox() -> TransitionsHandler?
    {
        switch self {
        case .animating(let weakBox):
            return weakBox.unbox()

        case .containing(let weakBox):
            return weakBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .animating(let weakBox):
            return weakBox.unbox()
        
        default:
            return nil
        }
    }
    
    public func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .containing(let weakBox):
            return weakBox.unbox()
        
        default:
            return nil
        }
    }
}
