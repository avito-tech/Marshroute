/// Варианты хранения обработчика переходов показываемого модуля
public enum PresentationTransitionTargetTransitionsHandlerBox {
    case Animating(strongBox: StrongBox<AnimatingTransitionsHandler>)
    case Containing(strongBox: StrongBox<ContainingTransitionsHandler>)
    case PendingAnimating // обработчик переходов будет выставлен позже

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .Animating(strongBox: StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .Containing(strongBox: StrongBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }
}

// MARK: - helpers
public extension PresentationTransitionTargetTransitionsHandlerBox {
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
            
        case .Containing(_):
            return nil
            
        case .PendingAnimating:
            return nil
        }
    }
    
    func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .Animating(_):
            return nil
            
        case .Containing(let weakBox):
            return weakBox.unbox()
            
        case .PendingAnimating:
            return nil
        }
    }
    
    var needsAnimatingTargetTransitionHandler: Bool {
        switch self {
        case .Animating(_):
            return false
            
        case .Containing(_):
           return false
            
        case .PendingAnimating:
            return true
        }
    }
}