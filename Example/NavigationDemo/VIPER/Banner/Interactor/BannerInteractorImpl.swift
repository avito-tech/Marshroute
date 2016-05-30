import Foundation

final class BannerInteractorImpl: BannerInteractor {
    private let timerService: TimerService
    
    // MARK: - Init
    init(timerService: TimerService) {
        self.timerService = timerService
    }
    
    // MARK: - BannerInteractor
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?) {
        timerService.startTimer(seconds: 1, onTick: onTick, onFire: onFire)
    }
    
    func invalidateTimer() {
        timerService.invalidateTimer()
    }
}
