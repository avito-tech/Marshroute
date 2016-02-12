/// Варианты хранения обработчика переходов показываемого модуля
enum ForwardTransitionTargetTransitionsHandlerBox {
    case Animating(AnimatingTransitionsHandlerStrongBox)
    case Containing(ContainingTransitionsHandlerStrongBox)
    case Pending // обработчик переходов будет выставлен позже
}

// MARK: - convenience
extension ForwardTransitionTargetTransitionsHandlerBox {
    init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .Animating(AnimatingTransitionsHandlerStrongBox(transitionsHandler: animatingTransitionsHandler))
    }
    
    init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .Containing(ContainingTransitionsHandlerStrongBox(transitionsHandler: containingTransitionsHandler))
    }
}

// MARK: - helpers
extension ForwardTransitionTargetTransitionsHandlerBox {
    func unbox() -> TransitionsHandler?
    {
        switch self {
        case .Animating(let animatingTransitionsHandlerWeakBox):
            return animatingTransitionsHandlerWeakBox.transitionsHandler
            
        case .Containing(let containingTransitionsHandlerWeakBox):
            return containingTransitionsHandlerWeakBox.transitionsHandler
            
        case .Pending:
            return nil
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