import Foundation

final class RecursionInteractorImpl: RecursionInteractor {
    private var timerService: TimerService?
    
    // MARK: - Init
    init(timerService: TimerService?) {
        self.timerService = timerService
    }
    
    // MARK: - RecursionInteractor
    func timerStatus(completion: (isEnabled: Bool) -> ()) {
        completion(isEnabled: timerService != nil)
    }
    
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?) {
        timerService?.startTimer(seconds: 6, onTick: onTick, onFire: onFire)
    }
}
