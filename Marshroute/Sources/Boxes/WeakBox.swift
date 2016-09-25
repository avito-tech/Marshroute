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
}

/*
 * если раскомментировать, то получим Segmentation fault: 11
 * до лучших времен Swift'а

extension WeakBox {
    init(other: StrongBox<T>)
    {
        self.boxedValue = other.unbox()
    }
}

*/
