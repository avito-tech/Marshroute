import Foundation

protocol FirstInteractor {
    weak var output: FirstPresenter? {get set}

    func canShowRedModule() -> Bool
    func shouldShowRedModule(forCount count: Int) -> Bool
    
    func canShowSecondModule() -> Bool
}
