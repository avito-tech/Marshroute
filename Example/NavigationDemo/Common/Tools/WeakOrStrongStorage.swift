// Иногда нужно свитчить способ хранения переменных.
// Если нужно порешать циклы, используется weak.
// Иначе используется strong.
//
// Примеры:
//
// myView.storage.store(subview, byWeakReference: false)
// myView.storage.store(superview, byWeakReference: true)
//
public final class WeakOrStrongStorage<T: AnyObject> {
    private weak var weakStorage: T?
    
    // just to store strongly, I didn't use T to prevent you to get value, because it is not needed
    private var strongStorage: Any?
    
    public var object: T? {
        return weakStorage
    }
    
    public var isStoredByWeakReference: Bool {
        return strongStorage == nil
    }
    
    public var isStoredByStrongReference: Bool {
        return !isStoredByWeakReference
    }
    
    public init() {
    }
    
    public func store(_ object: T?, byWeakReference: Bool) {
        weakStorage = object
        strongStorage = byWeakReference ? nil : object
    }
    
    public func weakify() {
        strongStorage = nil
    }
    
    public func strongify() {
        strongStorage = weakStorage
    }
}
