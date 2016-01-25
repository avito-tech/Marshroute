import Foundation

protocol FirstInteractorOutput: class {
    func setSecondsUntilTimerFiring(count: Int)
    func timerFired()
}
