import Foundation

class SecondInteractorImpl {
    weak var output: SecondPresenter?
    let withTimer: Bool
    
    init(withTimer: Bool) {
        self.withTimer = withTimer
    }
}

//MARK: - SecondInteractor
extension SecondInteractorImpl: SecondInteractor  {
    
}