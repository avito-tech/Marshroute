import Foundation

final class FirstInteractorImpl {
    weak var output: FirstInteractorOutput? 
    
    private let firstRedModuleEnabled: Bool
    private let secondModuleEnabled: Bool
    
    private let withTimer: Bool
    private let timerSeconds: Int
    private var timerSecondsTicked = 0
    private var timer: NSTimer?
    
    init (canShowFirstModule: Bool, canShowSecondModule: Bool, withTimer: Bool, timerSeconds: Int) {
        self.firstRedModuleEnabled = canShowFirstModule
        self.secondModuleEnabled = canShowSecondModule
        self.withTimer = withTimer
        self.timerSeconds = timerSeconds
    }
}

//MARK: - FirstInteractor
extension FirstInteractorImpl: FirstInteractor  {
    func canShowRedModule() -> Bool {
        return firstRedModuleEnabled
    }
    
    func shouldShowRedModule(forCount count: Int) -> Bool {
        return canShowRedModule() && count == 2
    }
    
    func canShowSecondModule() -> Bool {
        return secondModuleEnabled
    }
    
    func isTimerEnabled() -> Bool {
        return withTimer && timer == nil
    }
    
    func startTimer() {
        if isTimerEnabled() {
            startTimerImpl()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startTimerImpl() {
        output?.setSecondsUntilTimerFiring(timerSeconds)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
    }
    
    @objc private func onTimer(sender: NSTimer) {
        ++timerSecondsTicked
        output?.setSecondsUntilTimerFiring(timerSeconds - timerSecondsTicked)
        
        if timerSecondsTicked >= timerSeconds {
            timer?.invalidate()
            timer = nil
            
            timerSecondsTicked = 0
            output?.setSecondsUntilTimerFiring(0)
            output?.timerFired()
        }
    }
}