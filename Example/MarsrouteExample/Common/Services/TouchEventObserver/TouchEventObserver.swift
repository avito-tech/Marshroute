import Foundation

protocol TouchEventObserver: class {
    func addListener(_ listener: TouchEventListener)
}
