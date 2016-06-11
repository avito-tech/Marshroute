public enum WeakTransitionsHandlerBox {
    case Animating(WeakBox<AnimatingTransitionsHandler>)
    case Containing(WeakBox<ContainingTransitionsHandler>)
    
    // MARK: - Init
    public init(transitionsHandlerBox: TransitionsHandlerBox)
    {
        switch transitionsHandlerBox {
        case .Animating(let strongBox):
            let animatingTransitionsHandler = strongBox.unbox()
            self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .Containing(let strongBox):
            let containingTransitionsHandler = strongBox.unbox()
            self = .init(containingTransitionsHandler: containingTransitionsHandler)
        }
    }
    
    public init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .Animating(WeakBox(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .Containing(WeakBox(containingTransitionsHandler))
    }
    
    // MARK: - Public
    public func unbox() -> TransitionsHandler? {
        switch self {
        case .Animating(let animatingTransitionsHandlerBox):
            return animatingTransitionsHandlerBox.unbox()
            
        case .Containing(let containingTransitionsHandlerBox):
            return containingTransitionsHandlerBox.unbox()
        }
    }
}

public extension WeakTransitionsHandlerBox {
    func transitionsHandlerBox() -> TransitionsHandlerBox? {
        switch self {
        case .Animating(let animatingTransitionsHandlerBox):
            if let animatingTransitionsHandler = animatingTransitionsHandlerBox.unbox() {
                return TransitionsHandlerBox(animatingTransitionsHandler: animatingTransitionsHandler)
            }
            
        case .Containing(let containingTransitionsHandlerBox):
            if let containingTransitionsHandler = containingTransitionsHandlerBox.unbox() {
                return TransitionsHandlerBox(containingTransitionsHandler: containingTransitionsHandler)
            }
        }
        
        return nil
    }
}

public extension TransitionsHandlerBox {
    func weakTransitionsHandlerBox() -> WeakTransitionsHandlerBox {
        switch self {
        case .Animating(let animatingTransitionsHandlerBox):
            return WeakTransitionsHandlerBox(animatingTransitionsHandler: animatingTransitionsHandlerBox.unbox())
            
        case .Containing(let containingTransitionsHandlerBox):
            return WeakTransitionsHandlerBox(containingTransitionsHandler: containingTransitionsHandlerBox.unbox())
        }
    }
}