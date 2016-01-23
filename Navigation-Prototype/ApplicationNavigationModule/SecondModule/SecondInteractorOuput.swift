import Foundation

protocol SecondInteractorOutput: class {
    func setSecondsUntilTimerFiring(count: Int)
    func timerFired()
}
