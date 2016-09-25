public enum WeakTransitionsHandlerBox {
    case animating(WeakBox<AnimatingTransitionsHandler>)
    case containing(WeakBox<ContainingTransitionsHandler>)
    
    // MARK: - Init
    public init(transitionsHandlerBox: TransitionsHandlerBox)
    {
        switch transitionsHandlerBox {
        case .animating(let strongBox):
            let animatingTransitionsHandler = strongBox.unbox()
            self = .init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .containing(let strongBox):
            let containingTransitionsHandler = strongBox.unbox()
            self = .init(containingTransitionsHandler: containingTransitionsHandler)
        }
    }
    
    public init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .animating(WeakBox(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .containing(WeakBox(containingTransitionsHandler))
    }
    
    // MARK: - Public
    public func unbox() -> TransitionsHandler? {
        switch self {
        case .animating(let animatingTransitionsHandlerBox):
            return animatingTransitionsHandlerBox.unbox()
            
        case .containing(let containingTransitionsHandlerBox):
            return containingTransitionsHandlerBox.unbox()
        }
    }
}

public extension WeakTransitionsHandlerBox {
    func transitionsHandlerBox() -> TransitionsHandlerBox? {
        switch self {
        case .animating(let animatingTransitionsHandlerBox):
            if let animatingTransitionsHandler = animatingTransitionsHandlerBox.unbox() {
                return TransitionsHandlerBox(animatingTransitionsHandler: animatingTransitionsHandler)
            }
            
        case .containing(let containingTransitionsHandlerBox):
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
        case .animating(let animatingTransitionsHandlerBox):
            return WeakTransitionsHandlerBox(animatingTransitionsHandler: animatingTransitionsHandlerBox.unbox())
            
        case .containing(let containingTransitionsHandlerBox):
            return WeakTransitionsHandlerBox(containingTransitionsHandler: containingTransitionsHandlerBox.unbox())
        }
    }
}
