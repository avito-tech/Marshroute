import UIKit

//MARK: - ApplicationAssembly
protocol NavigationRootsHolder: class {
    var rootTransitionsHandler: TransitionsHandler? { get set }
    var window: UIWindow { get set }
}

//MARK: - ApplicationAssemblyImpl
private class NavigationRootsHolderImpl: NavigationRootsHolder {
    static var instance = NavigationRootsHolderImpl()
    var rootTransitionsHandler: TransitionsHandler?
    var window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
}

//MARK: - ApplicationAssemblyImpl
final class ApplicationAssemblyImpl: ApplicationAssembly {
    
    func module() -> (ApplicationModuleInput) {
        
        let interactor = ApplicationInteractorImpl()
        let router = ApplicationRouterImpl()
        
        let presenter = ApplicationPresenter(
            interactor: interactor,
            router: router
        )
        
        interactor.output = presenter
        
        do { // ApplicationNavigationModule
            let navigationRootsHolder = NavigationRootsHolderImpl.instance
            let window = navigationRootsHolder.window
            
            let navigationModule =  AssemblyFactory.applicationNavigationModuleAssembly().module(navigationRootsHolder)
            
            presenter.navigationModuleInput = navigationModule.1
            
            window.rootViewController = navigationModule.0
            window.makeKeyAndVisible()
        }
        
        return (presenter)
    }
    
}