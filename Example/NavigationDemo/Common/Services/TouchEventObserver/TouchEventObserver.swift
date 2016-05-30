import Foundation

protocol TouchEventObserver: class {
    func addListener(listener: TouchEventListener)
}
