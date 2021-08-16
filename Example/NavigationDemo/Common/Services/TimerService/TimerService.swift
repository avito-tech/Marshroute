import Foundation

protocol TimerService: AnyObject {
    func startTimer(
        seconds: TimeInterval,
        onTick: ((_ secondsLeft: TimeInterval) -> ())?,
        onFire: (() -> ())?)
    
    func invalidateTimer()
}
