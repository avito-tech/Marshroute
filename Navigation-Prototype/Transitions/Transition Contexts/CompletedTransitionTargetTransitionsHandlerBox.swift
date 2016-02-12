/// Варианты хранения обработчика переходов показанного модуля
enum CompletedTransitionTargetTransitionsHandlerBox {
    case Animating(AnimatingTransitionsHandlerWeakBox)
    case Containing(ContainingTransitionsHandlerWeakBox)
}

// MARK: - convenience
extension CompletedTransitionTargetTransitionsHandlerBox {
    init?(forwardTransitionTargetTransitionsHandlerBox: ForwardTransitionTargetTransitionsHandlerBox) {
        switch forwardTransitionTargetTransitionsHandlerBox {
        case .Animating(let animatingTransitionsHandlerStrongBox):
            let animatingTransitionsHandler = animatingTransitionsHandlerStrongBox.transitionsHandler
            self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .Containing(let containingTransitionsHandlerStrongBox):
            let containingTransitionsHandler = containingTransitionsHandlerStrongBox.transitionsHandler
            self = .init(containingTransitionsHandler: containingTransitionsHandler)

        default:
            return nil
        }
    }

    init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .Animating(AnimatingTransitionsHandlerWeakBox(transitionsHandler: animatingTransitionsHandler))
    }
    
    init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .Containing(ContainingTransitionsHandlerWeakBox(transitionsHandler: containingTransitionsHandler))
    }
}

// MARK: - helpers
extension CompletedTransitionTargetTransitionsHandlerBox {
    func unbox() -> TransitionsHandler?
    {
        switch self {
        case .Animating(let animatingTransitionsHandlerWeakBox):
            return animatingTransitionsHandlerWeakBox.transitionsHandler

        case .Containing(let containingTransitionsHandlerWeakBox):
            return containingTransitionsHandlerWeakBox.transitionsHandler
        }
    }
    
    func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .Animating(let animatingTransitionsHandlerWeakBox):
            return animatingTransitionsHandlerWeakBox.transitionsHandler
        
        default:
            return nil
        }
    }
    
    func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .Containing(let containingTransitionsHandlerWeakBox):
            return containingTransitionsHandlerWeakBox.transitionsHandler
        
        default:
            return nil
        }
    }
}