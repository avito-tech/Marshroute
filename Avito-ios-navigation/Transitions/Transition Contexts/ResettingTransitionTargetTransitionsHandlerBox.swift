/// Варианты хранения обработчика переходов показываемого модуля
public enum ResettingTransitionTargetTransitionsHandlerBox {
    case Animating(StrongBox<AnimatingTransitionsHandler>)

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .Animating(StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }

    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
        }
    }
}