import Foundation

protocol ShelfViewInput: AnyObject, ViewLifecycleObservable {
    func setTitle(_ title: String?)
}
