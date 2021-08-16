import Foundation

protocol TouchEventObserver: AnyObject {
    func addListener(_ listener: TouchEventListener)
}
