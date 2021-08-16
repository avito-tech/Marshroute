import Foundation

protocol RecursionInteractor: AnyObject {
    func timerStatus(_ completion: (_ isEnabled: Bool) -> ())
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?)
}
