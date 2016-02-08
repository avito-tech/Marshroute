import Foundation

final class ApplicationInteractorImpl {}

//MARK: - ApplicationInteractor
extension ApplicationInteractorImpl: ApplicationInteractor  {
    func authorizationStatus(completion: (authorized: Bool) -> Void) {
        let authorized = false // service.isAuthorized
        completion(authorized: authorized)
    }
}