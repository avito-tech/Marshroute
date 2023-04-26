/// Варианты хранения обработчика переходов показанного модуля
public enum TransitionsHandlerBox {
    case animating(AnimatingTransitionsHandler)
    case containing(ContainingTransitionsHandler)

    // MARK: - Init
    public init?(completedTransitionTargetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
    {
        switch completedTransitionTargetTransitionsHandlerBox {
        case .animating(let weakBox):
            if let animatingTransitionsHandler = weakBox.unbox() {
                self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            } else { return nil }

        case .containing(let weakBox):
            if let containingTransitionsHandler = weakBox.unbox() {
                self = .init(containingTransitionsHandler: containingTransitionsHandler)
            } else { return nil }
        }
    }
    
    public init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .animating(animatingTransitionsHandler)
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .containing(containingTransitionsHandler)
    }

    // MARK: - helpers
    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .animating(let animatingTransitionsHandler):
            return animatingTransitionsHandler
            
        case .containing(let containingTransitionsHandler):
            return containingTransitionsHandler
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .animating(let animatingTransitionsHandler):
            return animatingTransitionsHandler
            
        default:
            return nil
        }
    }
    
    public func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .containing(let containingTransitionsHandler):
            return containingTransitionsHandler
            
        default:
            return nil
        }
    }
    
    // MARK: - Convenience
    public func weakTransitionsHandlerBox() -> WeakTransitionsHandlerBox {
        switch self {
        case .animating(let animatingTransitionsHandler):
            return WeakTransitionsHandlerBox(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .containing(let containingTransitionsHandler):
            return WeakTransitionsHandlerBox(containingTransitionsHandler: containingTransitionsHandler)
        }
    }
}
