import UIKit

final class SecondAssemblyImpl: SecondAssembly {
    
    func iphoneModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String, withTimer: Bool) -> (UIViewController, SecondModuleInput) {
        
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5)
        let router = SecondRouterImpl()
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = SecondViewController(
            presenter: presenter,
            dismissable: parentRouter != nil
        )
        viewController.view.backgroundColor = .yellowColor()
        viewController.title = title
        viewController.output = presenter
        
        router.parentRouter = parentRouter                      //1
        router.transitionsHandler = transitionsHandler          //2
        router.setRootViewControllerIfNeeded(viewController)    //3
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
    
    func ipadModule(parentRouter parentRouter: RouterDismisable?, transitionsHandler: TransitionsHandler?, title: String, withTimer: Bool) -> (UIViewController, SecondModuleInput) {
        
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5)
        let router = SecondRouterImpl_iPad()
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = SecondViewController(
            presenter: presenter,
            dismissable: parentRouter != nil
        )
        viewController.view.backgroundColor = .yellowColor()
        viewController.title = title
        viewController.output = presenter
        
        router.parentRouter = parentRouter                      //1
        router.transitionsHandler = transitionsHandler          //2
        router.setRootViewControllerIfNeeded(viewController)    //3
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
    

    
}