public struct WeakBox<T> where T: AnyObject {
    fileprivate weak var boxedValue: T?
    
    public init(_ boxedValue: T)
    {
        self.boxedValue = boxedValue
    }
    
    public func unbox() -> T?
    {
        return boxedValue
    }

    init(_ other: StrongBox<T>)
    {
        self.boxedValue = other.unbox()
    }
    
    public func toStrongBox() -> StrongBox<T>? 
    {
        return StrongBox(self)
    }
}
