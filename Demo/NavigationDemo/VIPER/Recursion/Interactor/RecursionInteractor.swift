import Foundation

protocol RecursionInteractor: class {
    func timerStatus(completion: (isEnabled: Bool) -> ())
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?)
}