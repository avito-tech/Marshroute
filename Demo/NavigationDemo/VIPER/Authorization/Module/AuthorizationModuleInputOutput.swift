import Foundation

protocol AuthorizationModuleOutput: class {
    func autorizationModuleDidFinish(isAuthorized isAuthorized: Bool)
}
