/// Варианты хранения обработчика переходов показываемого модуля
public enum PresentationTransitionTargetTransitionsHandlerBox {
    case animating(AnimatingTransitionsHandler)
    case containing(ContainingTransitionsHandler)
    case pendingAnimating // обработчик переходов будет выставлен позже

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .animating(animatingTransitionsHandler)
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self = .containing(containingTransitionsHandler)
    }
    
    // MARK: - helpers
    var needsAnimatingTargetTransitionHandler: Bool
    {
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
