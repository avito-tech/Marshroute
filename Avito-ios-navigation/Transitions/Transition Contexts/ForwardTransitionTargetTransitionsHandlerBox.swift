/// Варианты хранения обработчика переходов показываемого модуля
public enum ForwardTransitionTargetTransitionsHandlerBox {
    case Animating(StrongBox<AnimatingTransitionsHandler>)
    case Containing(StrongBox<ContainingTransitionsHandler>)
    case PendingAnimating // обработчик переходов будет выставлен позже
}

// MARK: - convenience
public extension ForwardTransitionTargetTransitionsHandlerBox {
    init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .Animating(StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .Containing(StrongBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }
}

// MARK: - helpers
public extension ForwardTransitionTargetTransitionsHandlerBox {
    func unbox() -> TransitionsHandler?
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
            
        case .Containing(let weakBox):
            return weakBox.unbox()
            
        case .PendingAnimating:
            return nil
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
    
    var needsAnimatingTargetTransitionHandler: Bool {
        switch self {
        case .PendingAnimating:
            return true

        default:
            return false
        }
    }
}