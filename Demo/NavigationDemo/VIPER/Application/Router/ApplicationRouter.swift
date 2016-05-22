import AvitoNavigation

protocol ApplicationRouter: class {
    func showAuthorziation(moduleOutput moduleOutput: AuthorizationModuleOutput)
    func showCategories()
    func showRecursion()
}
