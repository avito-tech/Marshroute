public struct StrongBox<T> where T: AnyObject {
    fileprivate let boxedValue: T
    
    public init(_ boxedValue: T)
    {
        self.boxedValue = boxedValue
    }
    
    public func unbox() -> T
    {
        return boxedValue
    }

    public init?(_ other: WeakBox<T>)
    {
        guard let boxedValue = other.unbox()
            else { return nil }
        
        self.boxedValue = boxedValue
    }
    
    public func toWeakBox() -> WeakBox<T>
    {
        return WeakBox(self)
    }
}
