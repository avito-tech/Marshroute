/// Варианты хранения обработчика переходов показанного модуля
public enum TransitionsHandlerBox {
    case Animating(StrongBox<AnimatingTransitionsHandler>)
    case Containing(StrongBox<ContainingTransitionsHandler>)

    // MARK: - Init
    public init?(completedTransitionTargetTransitionsHandlerBox: CompletedTransitionTargetTransitionsHandlerBox)
    {
        switch completedTransitionTargetTransitionsHandlerBox {
        case .Animating(let weakBox):
            if let animatingTransitionsHandler = weakBox.unbox() {
                self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            }
            else { return nil }

        case .Containing(let weakBox):
            if let containingTransitionsHandler = weakBox.unbox() {
                self = .init(containingTransitionsHandler: containingTransitionsHandler)
            }
            else { return nil }
        }
    }
    
    public init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .Animating(StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .Containing(StrongBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }

    // MARK: - helpers
    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
            
        case .Containing(let weakBox):
            return weakBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
            
        default:
            return nil
        }
    }
    
    public func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .Containing(let weakBox):
            return weakBox.unbox()
            
        default:
            return nil
        }
    }
}