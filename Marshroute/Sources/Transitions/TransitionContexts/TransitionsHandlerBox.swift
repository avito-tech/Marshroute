/// Варианты хранения обработчика переходов показанного модуля
public enum TransitionsHandlerBox {
    case animating(strongBox: StrongBox<AnimatingTransitionsHandler>)
    case containing(strongBox: StrongBox<ContainingTransitionsHandler>)

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
        self = .animating(strongBox: StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .containing(strongBox: StrongBox<ContainingTransitionsHandler>(containingTransitionsHandler))
    }

    // MARK: - helpers
    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .animating(let strongBox):
            return strongBox.unbox()
            
        case .containing(let strongBox):
            return strongBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler?
    {
        switch self {
        case .animating(let strongBox):
            return strongBox.unbox()
            
        default:
            return nil
        }
    }
    
    public func unboxContainingTransitionsHandler() -> ContainingTransitionsHandler?
    {
        switch self {
        case .containing(let strongBox):
            return strongBox.unbox()
            
        default:
            return nil
        }
    }
}
