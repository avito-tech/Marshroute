import Foundation

final class TimerServiceImpl: TimerService {
    private var timer: NSTimer?
    private var interval: NSTimeInterval = 0
    private var onFire: (() -> ())?
    private var onTick: ((secondsLeft: NSTimeInterval) -> ())?
    
    // MARK: - TimerService
    func startTimer(
        seconds seconds: NSTimeInterval,
        onTick: ((secondsLeft: NSTimeInterval) -> ())?,
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
        onTick?(secondsLeft: interval)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1,
            target: self,
            selector: "onTimer:",
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func onTimer(sender: NSTimer) {
        interval -= 1
        
        if interval > 0 {
            scheduleTick()
        } else {
            onFire?()
        }
    }
}