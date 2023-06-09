import Foundation

// UPD: Observation of deinit doesn't work!
// Weak references to object become nil after deinit is called, but before object is deallocated.
// So we can't unsubscribe from KVO properly.
// So we made object not weak. All clients should manually set object to nil.
final class KeyValueObserver: NSObject {
    struct Change {
        let oldValue: Any?
        let newValue: Any?
        
        // Use it for optimisation of handling of change.
        // We can not guarantee that value is changed or not.
        //
        // Returns true if
        // 1. Values are changed
        // 2. Can not determine that values are changed or not
        //
        func valueIsChangedOrItCanNotBeDetermined() -> Bool {
            guard let oldValue = self.oldValue else {
                assertionFailure("KeyValueObserver: Old value is nil")
                return true // can not determine equality
            }
            guard let newValue = self.newValue as? NSObject else {
                assertionFailure("KeyValueObserver: New value is not NSObject")
                return true // can not determine equality
            }
            
            if newValue.isEqual(oldValue) {
                return false // definitely equal
            } else {
                return true // not equal or can not determine equality
            }
        }
    }
    
    typealias Observer = (Change) -> ()
    private struct ObserverAndSettings {
        let observer: Observer
        let ignoreIfUnchanged: Bool
    }
    
    // Pointers
    private var deinitObservableAssociatedObjectKey: UInt8 = 0
    private var kvoContext: UInt8 = 0
    
    private var objectStorage = WeakOrStrongStorage<NSObject>()
    private var observersByKeyPath: [String: ObserverAndSettings] = [:]
    
    private var notificationsAreEnabled = true
    
    var object: NSObject? {
        get {
            return objectStorage.object
        }
        set {
            setObject(newValue, byWeakReference: false)
        }
    }

    var weakObject: NSObject? {
        get {
            return objectStorage.object
        }
        set {
            setObject(newValue, byWeakReference: true)
        }
    }
    
    private func setObject(_ newValue: NSObject?, byWeakReference: Bool) {
        let oldValue = objectStorage.object
        let valueIsChanged = oldValue != newValue
        
        if valueIsChanged {
            if let oldValue = oldValue {
                stopBeingObserverForAllKeyPaths(oldValue)
            }
            
            setUpObservingObjectDeinit(
                oldObject: oldValue,
                newObject: newValue
            )
        }
        
        objectStorage.store(newValue, byWeakReference: byWeakReference)
        
        if valueIsChanged {
            if let newValue = newValue {
                for (keyPath, _) in observersByKeyPath {
                    becomeObserver(newValue, keyPath: keyPath)
                }
            }
        }
    }
    
    func setObserver(_ observer: @escaping Observer, keyPath: String, ignoreIfUnchanged: Bool = true) {
        observersByKeyPath[keyPath] = ObserverAndSettings(
            observer: observer,
            ignoreIfUnchanged: ignoreIfUnchanged
        )
        
        if let object = object {
            becomeObserver(object, keyPath: keyPath)
        }
    }
    
    func observe(_ keyPath: String, observer: @escaping Observer) {
        setObserver(observer, keyPath: keyPath)
    }
    
    func removeObserver(_ keyPath: String) {
        observersByKeyPath.removeValue(forKey: keyPath)
        
        if let object = object {
            stopBeingObserver(object, keyPath: keyPath)
        }
    }
    
    func removeAllObservers() {
        if let object = object {
            for (keyPath, _) in observersByKeyPath {
                stopBeingObserver(object, keyPath: keyPath)
            }
        }
        
        observersByKeyPath.removeAll(keepingCapacity: false)
    }
    
    func withoutObservingDo(_ closure: () -> ()) {
        let notificationsAreEnabled = self.notificationsAreEnabled
        self.notificationsAreEnabled = false
        closure()
        self.notificationsAreEnabled = notificationsAreEnabled
    }
    
    deinit {
        removeAllObservers()
    }
    
    // swiftlint:disable:next block_based_kvo
    @objc override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?)
    {
        if let keyPath = keyPath, context == &kvoContext {
            if let observerAndSettings = observersByKeyPath[keyPath], notificationsAreEnabled {
                withoutObservingDo {
                    if let kvoChange = change {
                        let change = Change(
                            oldValue: kvoChange[.oldKey],
                            newValue: kvoChange[.newKey]
                        )
                        
                        let shouldNotify = observerAndSettings.ignoreIfUnchanged
                            ? change.valueIsChangedOrItCanNotBeDetermined() // false == ignore
                            : true
                        
                        if shouldNotify {
                            observerAndSettings.observer(change)
                        }
                        
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func becomeObserver(_ object: AnyObject, keyPath: String) {
        let options = NSKeyValueObservingOptions([.new, .old])
        object.addObserver(self, forKeyPath: keyPath, options: options, context: &kvoContext)
    }
    
    private func stopBeingObserver(_ object: AnyObject, keyPath: String) {
        object.removeObserver(self, forKeyPath: keyPath, context: &kvoContext)
    }
    
    private func stopBeingObserverForAllKeyPaths(_ object: AnyObject) {
        for (keyPath, _) in observersByKeyPath {
            stopBeingObserver(object, keyPath: keyPath)
        }
    }
    
    private func setUpObservingObjectDeinit(oldObject: NSObject?, newObject: NSObject?) {
        class DeinitObservable: NSObject {
            var onDeinit: (() -> ())?
            
            deinit {
                onDeinit?()
            }
        }
        
        if let oldObject = oldObject {
            // Remove deinit observable from oldObject
            
            // Get old DeinitObservable
            let deinitObservableAssociatedObject = objc_getAssociatedObject(
                oldObject,
                &deinitObservableAssociatedObjectKey
            )
            
            // Unsubscribe from it
            if let deinitObservable = deinitObservableAssociatedObject as? DeinitObservable {
                deinitObservable.onDeinit = nil
            }
            
            // Delete it (we've unsubscribed before, so onDeinit will not do anything)
            objc_setAssociatedObject(
                oldObject,
                &deinitObservableAssociatedObjectKey,
                nil,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        
        if let newObject = newObject {
            let deinitObservableAssociatedObject = objc_getAssociatedObject(
                newObject,
                &deinitObservableAssociatedObjectKey
            )
            
            let deinitObservable: DeinitObservable
            
            if let deinitObservableAssociatedObject = deinitObservableAssociatedObject as? DeinitObservable {
                deinitObservable = deinitObservableAssociatedObject
            } else {
                deinitObservable = DeinitObservable()
                objc_setAssociatedObject(
                    newObject,
                    &deinitObservableAssociatedObjectKey,
                    deinitObservable,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
            
            deinitObservable.onDeinit = { [weak self, weak newObject] in
                if let newObject = newObject, self?.object === newObject {
                    self?.stopBeingObserverForAllKeyPaths(newObject)
                }
            }
        }
    }
}
