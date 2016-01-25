import Foundation

protocol FirstViewInput: class {
    func setSecondButtonEnabled(enabled: Bool)
    
    func setSecondsUntilTimerEnabled(cound: Int)
    func setTimerTurnedOn(turned: Bool)
    func setTimerInteractionEnabled(enabled: Bool)
}