import Foundation

protocol ApplicationViewInput: class, ViewLifecycleObservable {
    func showBanner(completion: (() -> ())?)
    func hideBanner()
    
    var onMemoryWarning: (() -> ())? { get set }
    var onDeviceShake: (() -> ())? { get set }
}
