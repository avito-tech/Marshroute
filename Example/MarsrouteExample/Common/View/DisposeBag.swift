protocol DisposeBag {
    func addDisposable(_ anyObject: AnyObject)
}

// Default `DisposeBag` implementation
extension DisposeBag where Self: DisposeBagHolder {
    func addDisposable(_ anyObject: AnyObject) {
        disposeBag.addDisposable(anyObject)
    }
}

// Non thread safe `DisposeBag` implementation
final class DisposeBagImpl: DisposeBag {
    fileprivate var disposables: [AnyObject] = []
    
    func addDisposable(_ anyObject: AnyObject) {
        disposables.append(anyObject)
    }
}
