import AvitoNavigation

protocol ApplicationRouter: class {
    func authorizationStatus(completion: ((isPresented: Bool) -> ()))
    func showAuthorziation(moduleOutput moduleOutput: AuthorizationModuleOutput)
    func showCategories()
    func showRecursion()
}
