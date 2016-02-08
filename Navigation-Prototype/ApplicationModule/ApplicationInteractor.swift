import Foundation

protocol ApplicationInteractor: class {
    func authorizationStatus(completion: (authorized: Bool) -> Void)
}