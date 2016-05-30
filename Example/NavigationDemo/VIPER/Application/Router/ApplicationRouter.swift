import Marshroute

protocol ApplicationRouter: class {
    func authorizationStatus(completion: ((isPresented: Bool) -> ()))
    func showAuthorziation(prepareForTransition: ((moduleInput: AuthorizationModuleInput) -> ()))
    func showCategories()
    func showRecursion()
}
