import Foundation

class SecondInteractorImpl {
    weak var output: SecondInteractorOutput?

    private let withTimer: Bool
    private let timerSeconds: Int
    private var timerSecondsTicked = 0
    private var timer: NSTimer?
    
    init(withTimer: Bool, timerSeconds: Int) {
        self.withTimer = withTimer
        self.timerSeconds = timerSeconds
    }
}

//MARK: - SecondInteractor
extension SecondInteractorImpl: SecondInteractor  {
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