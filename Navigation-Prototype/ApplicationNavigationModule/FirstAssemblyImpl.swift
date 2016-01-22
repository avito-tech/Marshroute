import Foundation

final class FirstAssemblyImpl: FirstAssembly {
    
    func module(title: String, parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, forIphone: Bool, moduleChangeable: Bool) -> (FirstViewController, FirstModuleInput){
        
        let interactor = FirstInteractorImpl(moduleChangeable: moduleChangeable)

        let router = FirstRouterImpl()
        router.parentRouter = parentRouter
        router.transitionsHandler = transitionsHandler
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter
        )
        viewController.view.backgroundColor = moduleChangeable ? .whiteColor() : .redColor()

        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
    
        return (viewController, presenter)
    }
    
}