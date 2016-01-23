import UIKit

final class SecondViewImpl: UIView {
    weak var output: SecondViewOutput?
}

//MARK: - SecondViewInput
extension SecondViewImpl: SecondViewInput  {
    func setSecondsUntilTimerEnabled(cound: Int) {}
    func setTimerTurnedOn(turned: Bool) {}
    func setTimerInteractionEnabled(enabled: Bool) {}
    func setToModule1TurnedOn(turned: Bool) {}
}