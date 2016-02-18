/// Варианты хранения обработчика переходов показанного модуля
public enum CompletedTransitionTargetTransitionsHandlerBox {
    case Animating(WeakBox<AnimatingTransitionsHandler>)
    case Containing(WeakBox<ContainingTransitionsHandler>)
}

// MARK: - convenience
extension CompletedTransitionTargetTransitionsHandlerBox {
    init?(forwardTransitionTargetTransitionsHandlerBox: ForwardTransitionTargetTransitionsHandlerBox)
    {
        switch forwardTransitionTargetTransitionsHandlerBox {
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

    init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .Animating(WeakBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .Containing(WeakBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }
}

// MARK: - helpers
extension CompletedTransitionTargetTransitionsHandlerBox {
    func unbox() -> TransitionsHandler?
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()

        case .Containing(let weakBox):
            return weakBox.unbox()
        }
    }
    
    func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
        
        default:
            return nil
        }
    }
    
    func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .Containing(let weakBox):
            return weakBox.unbox()
        
        default:
            return nil
        }
    }
}