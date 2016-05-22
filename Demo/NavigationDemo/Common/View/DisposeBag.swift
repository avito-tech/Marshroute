protocol DisposeBag {
    func addDisposable(anyObject: AnyObject)
}

// Default `DisposeBag` implementation
extension DisposeBag where Self: DisposeBagHolder {
    func addDisposable(anyObject: AnyObject) {
        disposeBag.addDisposable(anyObject)
    }
}

// Non thread safe `DisposeBag` implementation
final class DisposeBagImpl: DisposeBag {
    private var disposables: [AnyObject] = []
    
    func addDisposable(anyObject: AnyObject) {
        disposables.append(anyObject)
    }
}