import Foundation

protocol BannerInteractor: class {
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?)
    func invalidateTimer()
}
