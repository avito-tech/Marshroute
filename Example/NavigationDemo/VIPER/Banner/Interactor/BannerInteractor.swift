import Foundation

protocol BannerInteractor: class {
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?)
    func invalidateTimer()
}