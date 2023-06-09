final class WeakBox<T> where T: AnyObject {
    private(set) weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}