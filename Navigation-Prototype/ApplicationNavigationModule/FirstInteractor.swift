import Foundation

protocol FirstInteractor {
    weak var output: FirstPresenter? {get set}

    func canChangeModule() -> Bool
    func shouldChangeModule(forCount count: Int) -> Bool
}
