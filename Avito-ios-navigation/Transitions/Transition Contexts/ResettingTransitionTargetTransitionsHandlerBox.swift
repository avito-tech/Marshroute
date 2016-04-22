/// Варианты хранения обработчика переходов показываемого модуля
public enum ResettingTransitionTargetTransitionsHandlerBox {
    case Animating(StrongBox<NavigationTransitionsHandlerImpl>)

    public init(animatingTransitionsHandler: NavigationTransitionsHandlerImpl)
    {
        self = .Animating(StrongBox<NavigationTransitionsHandlerImpl>(animatingTransitionsHandler))
    }

    public func unbox() -> TransitionsHandler
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
        }
    }
    
    public func unboxAnimatingTransitionsHandler() -> NavigationTransitionsHandlerImpl
    {
        switch self {
        case .Animating(let weakBox):
            return weakBox.unbox()
        }
    }
}