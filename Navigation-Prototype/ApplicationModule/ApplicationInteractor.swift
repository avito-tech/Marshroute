import Foundation

protocol ApplicationInteractor: class {
    func requestAuthorizationStatus(completion: (authorized: Bool) -> Void)
}