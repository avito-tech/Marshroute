import Foundation

final class ApplicationInteractorImpl {
    weak var output: ApplicationPresenter?
}

//MARK: - ApplicationInteractor
extension ApplicationInteractorImpl: ApplicationInteractor  {
    func requestAuthorizationStatus(completion: (authorized: Bool) -> Void) {
        let authorized = false // service.isAuthorized
        completion(authorized: authorized)
    }
}