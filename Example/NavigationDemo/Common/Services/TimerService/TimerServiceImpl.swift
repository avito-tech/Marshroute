import Foundation

final class TimerServiceImpl: TimerService {
    private var timer: Timer?
    private var interval: TimeInterval = 0
    private var onFire: (() -> ())?
    private var onTick: ((_ secondsLeft: TimeInterval) -> ())?
    
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
    private func scheduleTick() {
        onTick?(interval)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(onTimer(_:)),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func onTimer(_ sender: Timer) {
        interval -= 1
        
        if interval > 0 {
            scheduleTick()
        } else {
            onFire?()
        }
    }
}
