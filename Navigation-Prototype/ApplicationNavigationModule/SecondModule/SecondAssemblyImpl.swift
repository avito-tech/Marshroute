import UIKit

final class SecondAssemblyImpl: SecondAssembly {
    
    func iphoneModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String, withTimer: Bool) -> (UIViewController, SecondModuleInput) {
        
        let interactor = SecondInteractorImpl(withTimer: withTimer)
        let router = SecondRouterImpl()
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = SecondViewController(
            presenter: presenter
        )
        viewController.view.backgroundColor = .whiteColor()
        viewController.title = title

        router.parentRouter = parentRouter
        router.transitionsHandler = transitionsHandler
        router.setRootViewControllerIfNeeded(viewController)
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
    
    func ipadModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String, withTimer: Bool) -> (UIViewController, SecondModuleInput) {
        
        let interactor = SecondInteractorImpl(withTimer: withTimer)
        let router = SecondRouterImpl_iPad()
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = SecondViewController(
            presenter: presenter
        )
        viewController.view.backgroundColor = .whiteColor()
        viewController.title = title
        
        router.parentRouter = parentRouter
        router.transitionsHandler = transitionsHandler
        router.setRootViewControllerIfNeeded(viewController)
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
    

    
}