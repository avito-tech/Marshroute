public enum WeakTransitionsHandlerBox {
    case animating(WeakAnimatingTransitionsHandlerBox)
    case containing(WeakContainingTransitionsHandlerBox)
    
    // MARK: - Init
    public init(transitionsHandlerBox: TransitionsHandlerBox)
    {
        switch transitionsHandlerBox {
        case .animating(let animatingTransitionsHandler):
            self.init(animatingTransitionsHandler: animatingTransitionsHandler)
            
        case .containing(let containingTransitionsHandler):
            self.init(containingTransitionsHandler: containingTransitionsHandler)
        }
    }
    
    public init(animatingTransitionsHandler: AnimatingTransitionsHandler) {
        self = .animating(WeakAnimatingTransitionsHandlerBox(animatingTransitionsHandler))
    }
    
    public init(containingTransitionsHandler: ContainingTransitionsHandler) {
        self = .containing(WeakContainingTransitionsHandlerBox(containingTransitionsHandler))
    }
    
    // MARK: - Public
    public func unbox() -> TransitionsHandler? {
        switch self {
        case .animating(let weakAnimatingTransitionsHandlerBox):
            return weakAnimatingTransitionsHandlerBox.unbox()
            
        case .containing(let weakContainingTransitionsHandlerBox):
            return weakContainingTransitionsHandlerBox.unbox()
        }
    }
    
    // MARK: - Convenience
    public func transitionsHandlerBox() -> TransitionsHandlerBox? {
        switch self {
        case .animating(let weakAnimatingTransitionsHandlerBox):
            if let animatingTransitionsHandler = weakAnimatingTransitionsHandlerBox.unbox() {
                return TransitionsHandlerBox(animatingTransitionsHandler: animatingTransitionsHandler)
            }
            
        case .containing(let weakContainingTransitionsHandlerBox):
            if let containingTransitionsHandler = weakContainingTransitionsHandlerBox.unbox() {
                return TransitionsHandlerBox(containingTransitionsHandler: containingTransitionsHandler)
            }
        }
        
        return nil
    }
}

// Эти врапперы существуют из-за ограничения Swift'а в виде ошибки `type A requires that type B be a class type`,
// которая возникает в случаях, когда пытаешься сделать генерик тип `Box<T: AnimatingTransitionsHandler>` и в конструкторе
// передаешь протокол вместо конкретного класса (не помогает даже сделать `init(t: some AnimatingTransitionsHandler)`

public final class WeakAnimatingTransitionsHandlerBox {
    private weak var animatingTransitionsHandler: AnimatingTransitionsHandler?

    public init(_ animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        self.animatingTransitionsHandler = animatingTransitionsHandler
    }
    
    public func unbox() -> AnimatingTransitionsHandler? {
        animatingTransitionsHandler
    }
}

public final class WeakContainingTransitionsHandlerBox {
    private weak var containingTransitionsHandler: ContainingTransitionsHandler?

    public init(_ containingTransitionsHandler: ContainingTransitionsHandler)
    {
        self.containingTransitionsHandler = containingTransitionsHandler
    }
    
    public func unbox() -> ContainingTransitionsHandler? {
        containingTransitionsHandler
    }
}
