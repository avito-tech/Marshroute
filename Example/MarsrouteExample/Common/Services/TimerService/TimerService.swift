import Foundation

protocol TimerService: class {
    func startTimer(
        seconds: TimeInterval,
        onTick: ((_ secondsLeft: TimeInterval) -> ())?,
        onFire: (() -> ())?)
    
    func invalidateTimer()
}
