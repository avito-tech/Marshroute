import Marshroute

protocol ApplicationRouter: class {
    func authorizationStatus(completion: ((isPresented: Bool) -> ()))
    func showAuthorization(prepareForTransition: ((moduleInput: AuthorizationModuleInput) -> ()))
    func showCategories()
    func showRecursion()
}
