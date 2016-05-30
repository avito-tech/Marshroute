import Foundation

protocol TimerService: class {
    func startTimer(
        seconds seconds: NSTimeInterval,
        onTick: ((secondsLeft: NSTimeInterval) -> ())?,
        onFire: (() -> ())?)
    
    func invalidateTimer()
}
