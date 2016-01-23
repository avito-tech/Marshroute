import Foundation

protocol SecondViewInput: class {
    func setSecondsUntilTimerEnabled(cound: Int)
    func setTimerTurnedOn(turned: Bool)
    func setTimerInteractionEnabled(enabled: Bool)
}