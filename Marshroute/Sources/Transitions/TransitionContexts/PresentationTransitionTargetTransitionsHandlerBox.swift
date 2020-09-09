/// Варианты хранения обработчика переходов показываемого модуля
public enum PresentationTransitionTargetTransitionsHandlerBox {
    case animating(strongBox: StrongBox<AnimatingTransitionsHandler>)
    case containing(strongBox: StrongBox<ContainingTransitionsHandler>)
    case pendingAnimating // обработчик переходов будет выставлен позже

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .animating(strongBox: StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .containing(strongBox: StrongBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }
}

// MARK: - helpers
public extension PresentationTransitionTargetTransitionsHandlerBox {
    func unbox() -> TransitionsHandler?
    {
        switch self {
        case .animating(let strongBox):
            return strongBox.unbox()
            
        case .containing(let strongBox):
            return strongBox.unbox()
            
        case .pendingAnimating:
            return nil
        }
    }
    
    func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .animating(let strongBox):
            return strongBox.unbox()
            
        case .containing:
            return nil
            
        case .pendingAnimating:
            return nil
        }
    }
    
    func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .animating:
            return nil
            
        case .containing(let strongBox):
            return strongBox.unbox()
            
        case .pendingAnimating:
            return nil
        }
    }
    
    var needsAnimatingTargetTransitionHandler: Bool {
        switch self {
        case .animating:
            return false
            
        case .containing:
           return false
            
        case .pendingAnimating:
            return true
        }
    }
}
