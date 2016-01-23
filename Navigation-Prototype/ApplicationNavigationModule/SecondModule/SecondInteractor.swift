import Foundation

protocol SecondInteractor {    
    func isTimerEnabled() -> Bool
    func startTimer()
    func stopTimer()
    func canShowModule1() -> Bool
}
