/// Варианты хранения обработчика переходов показанного модуля
enum TransitionsHandlerBox {
    case Animating(AnimatingTransitionsHandlerStrongBox)
    case Containing(ContainingTransitionsHandlerStrongBox)
}

// MARK: - convenience
extension TransitionsHandlerBox {
    init?(completedTransitionTargetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
    {
        switch completedTransitionTargetTransitionsHandlerBox {
        case .Animating(let AnimatingTransitionsHandlerWeakBox):
            if let transitionsHandler = AnimatingTransitionsHandlerWeakBox.transitionsHandler {
                self = .Animating(AnimatingTransitionsHandlerStrongBox(transitionsHandler: transitionsHandler))
            }
            else { return nil }

        case .Containing(let ContainingTransitionsHandlerWeakBox):
            if let transitionsHandler = ContainingTransitionsHandlerWeakBox.transitionsHandler {
                self = .Containing(ContainingTransitionsHandlerStrongBox(transitionsHandler: transitionsHandler))
            }
            else { return nil }
        }
    }
    
    init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .Animating(AnimatingTransitionsHandlerStrongBox(transitionsHandler: animatingTransitionsHandler))
    }
    
    init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .Containing(ContainingTransitionsHandlerStrongBox(transitionsHandler: containingTransitionsHandler))
    }
}

// MARK: - helpers
extension TransitionsHandlerBox {
    func matches(transitionsHandler transitionsHandler: TransitionsHandler) -> Bool
    {
        switch self {
        case .Animating(let AnimatingTransitionsHandlerStrongBox):
            return (AnimatingTransitionsHandlerStrongBox.transitionsHandler === transitionsHandler)
            
        case .Containing(let ContainingTransitionsHandlerStrongBox):
            return (ContainingTransitionsHandlerStrongBox.transitionsHandler === transitionsHandler)
        }
    }
    
    func unbox() -> TransitionsHandler
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