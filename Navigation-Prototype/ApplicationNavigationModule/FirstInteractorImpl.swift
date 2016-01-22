import Foundation

class FirstInteractorImpl {
    weak var output: FirstPresenter?
    
    let moduleChangeable: Bool
    
    init (moduleChangeable: Bool) {
        self.moduleChangeable = moduleChangeable
    }
}

//MARK: - FirstInteractor
extension FirstInteractorImpl: FirstInteractor  {
    func canChangeModule() -> Bool {
        return moduleChangeable
    }
    
    func shouldChangeModule(forCount count: Int) -> Bool {
        return moduleChangeable && count == 2
    }
}