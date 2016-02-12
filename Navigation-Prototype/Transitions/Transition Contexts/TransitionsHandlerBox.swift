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
        case .Animating(let animatingTransitionsHandlerWeakBox):
            if let animatingTransitionsHandler = animatingTransitionsHandlerWeakBox.transitionsHandler {
                self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            }
            else { return nil }

        case .Containing(let containingTransitionsHandlerWeakBox):
            if let containingTransitionsHandler = containingTransitionsHandlerWeakBox.transitionsHandler {
                self = .init(containingTransitionsHandler: containingTransitionsHandler)
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