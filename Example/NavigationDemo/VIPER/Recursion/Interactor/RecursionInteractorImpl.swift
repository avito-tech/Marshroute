import Foundation

final class RecursionInteractorImpl: RecursionInteractor {
    fileprivate var timerService: TimerService?
    
    // MARK: - Init
    init(timerService: TimerService?) {
        self.timerService = timerService
    }
    
    // MARK: - RecursionInteractor
    func timerStatus(_ completion: (_ isEnabled: Bool) -> ()) {
        completion(timerService != nil)
    }
    
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?) {
        timerService?.startTimer(seconds: 6, onTick: onTick, onFire: onFire)
    }
}
