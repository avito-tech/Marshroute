import Foundation

protocol BannerInteractor: AnyObject {
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?)
    func invalidateTimer()
}
