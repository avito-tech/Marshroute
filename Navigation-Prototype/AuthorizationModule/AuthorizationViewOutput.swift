import Foundation

protocol AuthorizationViewOutput: class {
    func userDidCancel()
    func userDidAuth()
}