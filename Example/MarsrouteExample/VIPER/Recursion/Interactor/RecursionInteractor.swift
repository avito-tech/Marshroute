import Foundation

protocol RecursionInteractor: class {
    func timerStatus(_ completion: (_ isEnabled: Bool) -> ())
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?)
}
