struct StrongBox<T where T: AnyObject> {
    private let boxedValue: T
    
    init(_ boxedValue: T)
    {
        self.boxedValue = boxedValue
    }
    
    func unbox()-> T
    {
        return boxedValue
    }
}

extension StrongBox {
    init?(other: WeakBox<T>)
    {
        guard let boxedValue = other.unbox()
            else { return nil }
        
        self.boxedValue = boxedValue
    }
}