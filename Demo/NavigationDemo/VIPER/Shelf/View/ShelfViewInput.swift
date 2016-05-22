import Foundation

protocol ShelfViewInput: class, ViewLifecycleObservable {
    func setTitle(title: String?)
}
