/// Варианты хранения обработчика переходов показываемого модуля
public enum ResettingTransitionTargetTransitionsHandlerBox {
    case Animating(strongBox: StrongBox<AnimatingTransitionsHandler>)

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .Animating(strongBox: StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }

    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .Animating(let strongBox):
            return strongBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler
    {
        switch self {
        case .Animating(let strongBox):
            return strongBox.unbox()
        }
    }
}