import Marshroute

enum WeakTransitionsHandlerBox {
    case Animating(WeakBox<AnimatingTransitionsHandler>)
    case Containing(WeakBox<ContainingTransitionsHandler>)
    
    // MARK: - Init
    init(transitionsHandlerBox: TransitionsHandlerBox)
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
    
    init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .Animating(WeakBox(animatingTransitionsHandler))
    }
    
    init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .Containing(WeakBox(containingTransitionsHandler))
    }
    
    // MARK: - Internal
    func unbox() -> TransitionsHandler? {
        switch self {
        case .Animating(let animatingTransitionsHandlerBox):
            return animatingTransitionsHandlerBox.unbox()
            
        case .Containing(let containingTransitionsHandlerBox):
            return containingTransitionsHandlerBox.unbox()
        }
    }
}

extension WeakTransitionsHandlerBox {
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