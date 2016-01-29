import Foundation

protocol AuthorizationModuleOutput: class {
    func didFinishWith(success success: Bool)
}