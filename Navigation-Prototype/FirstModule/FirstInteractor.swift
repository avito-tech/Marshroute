import Foundation

protocol FirstInteractor {
    func canShowRedModule() -> Bool
    func shouldShowRedModule(forCount count: Int) -> Bool
    
    func canShowSecondModule() -> Bool
    
    func isTimerEnabled() -> Bool

    func startTimer()
    
    func stopTimer()
}
