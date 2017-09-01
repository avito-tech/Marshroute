import Foundation

final class TimerServiceImpl: TimerService {
    fileprivate var timer: Timer?
    fileprivate var interval: TimeInterval = 0
    fileprivate var onFire: (() -> ())?
    fileprivate var onTick: ((_ secondsLeft: TimeInterval) -> ())?
    
    // MARK: - TimerService
    func startTimer(
        seconds: TimeInterval,
        onTick: ((_ secondsLeft: TimeInterval) -> ())?,
        onFire: (() -> ())?)
    {
        timer?.invalidate()
        
        self.interval = seconds
        
        self.onTick = onTick
        
        self.onFire = { [weak self] in
            self?.timer = nil
            
            self?.interval = 0
            self?.onTick = nil
            self?.onFire = nil
            
            onFire?()
        }
        
        scheduleTick()
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
        
        interval = 0
        onTick = nil
        onFire = nil
    }
    
    // MARK: - Private
    fileprivate func scheduleTick() {
        onTick?(interval)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(onTimer(_:)),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc fileprivate func onTimer(_ sender: Timer) {
        interval -= 1
        
        if interval > 0 {
            scheduleTick()
        } else {
            onFire?()
        }
    }
}
