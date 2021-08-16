import Marshroute

protocol ApplicationRouter: AnyObject {
    func authorizationStatus(_ completion: ((_ isPresented: Bool) -> ()))
    func showAuthorization(_ prepareForTransition: ((_ moduleInput: AuthorizationModuleInput) -> ()))
    func showCategories()
    func showRecursion()
}
