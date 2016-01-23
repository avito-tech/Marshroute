import Foundation

class FirstInteractorImpl {
    weak var output: FirstPresenter?
    
    let firstRedModuleEnabled: Bool
    let secondModuleEnabled: Bool
    
    init (canShowFirstModule: Bool, canShowSecondModule: Bool) {
        self.firstRedModuleEnabled = canShowFirstModule
        self.secondModuleEnabled = canShowSecondModule
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
}