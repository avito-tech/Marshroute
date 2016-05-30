public struct StrongBox<T where T: AnyObject> {
    private let boxedValue: T
    
    public init(_ boxedValue: T)
    {
        self.boxedValue = boxedValue
    }
    
    public func unbox() -> T
    {
        return boxedValue
    }
}

public extension StrongBox {
    init?(other: WeakBox<T>)
    {
        guard let boxedValue = other.unbox()
            else { return nil }
        
        self.boxedValue = boxedValue
    }
}