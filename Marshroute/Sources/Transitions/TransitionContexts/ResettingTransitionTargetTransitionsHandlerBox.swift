/// Варианты хранения обработчика переходов показываемого модуля
public enum ResettingTransitionTargetTransitionsHandlerBox {
    case animating(strongBox: StrongBox<AnimatingTransitionsHandler>)

    public init(animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self = .animating(strongBox: StrongBox<AnimatingTransitionsHandler>(animatingTransitionsHandler))
    }

    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .animating(let strongBox):
            return strongBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> AnimatingTransitionsHandler
    {
        switch self {
        case .animating(let strongBox):
            return strongBox.unbox()
        }
    }
}
