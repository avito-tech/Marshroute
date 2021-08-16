import Foundation

protocol ApplicationViewInput: AnyObject, ViewLifecycleObservable {
    func showBanner(_ completion: (() -> ())?)
    func hideBanner()
    
    var onMemoryWarning: (() -> ())? { get set }
    var onDeviceShake: (() -> ())? { get set }
}
