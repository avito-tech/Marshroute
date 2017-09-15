import Foundation

protocol ShelfViewInput: class, ViewLifecycleObservable {
    func setTitle(_ title: String?)
}
