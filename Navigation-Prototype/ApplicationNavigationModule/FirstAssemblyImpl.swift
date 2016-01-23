import Foundation

final class FirstAssemblyImpl: FirstAssembly {

    func iphoneModule(title: String, parentRouter: RouterDismisable?,
        transitionsHandler: TransitionsHandler?,
        canShowFirstModule: Bool, canShowSecondModule: Bool)
        -> (FirstViewController, FirstModuleInput) {
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule)

        let router = FirstRouterImpl()
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter
        )
        viewController.view.backgroundColor = canShowFirstModule ? .whiteColor() : .redColor()

        viewController.title = title
        viewController.output = presenter
            
        router.parentRouter = parentRouter                      //1
        router.transitionsHandler = transitionsHandler          //2
        router.setRootViewControllerIfNeeded(viewController)    //3
        
        presenter.viewInput = viewController
        interactor.output = presenter
    
        return (viewController, presenter)
    }
    
    func ipadDetailModule(title: String, parentRouter: RouterDismisable?,
        transitionsHandler: TransitionsHandler?,
        canShowFirstModule: Bool, canShowSecondModule: Bool)
        -> (FirstViewController, FirstModuleInput) {
            
            let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule)
            
            let router = FirstRouterImpl_iPad()
            
            let presenter = FirstPresenter(
                interactor: interactor,
                router: router
            )
            
            let viewController = FirstViewController(
                presenter: presenter
            )
            viewController.view.backgroundColor = canShowFirstModule ? .whiteColor() : .redColor()
            
            viewController.title = title
            viewController.output = presenter
            
            router.parentRouter = parentRouter                      //1
            router.transitionsHandler = transitionsHandler          //2
            router.setRootViewControllerIfNeeded(viewController)    //3
            
            presenter.viewInput = viewController
            interactor.output = presenter
            
            return (viewController, presenter)
    }
    
    func ipadMasterModule(title: String, parentRouter: RouterDismisable?,
        transitionsHandler: TransitionsHandler?, detailTransitionsHandler: TransitionsHandler?,
        canShowFirstModule: Bool, canShowSecondModule: Bool)
        -> (FirstViewController, FirstModuleInput) {
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule)
        
        let router = FirstRouterImpl_iPad()
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter
        )
        viewController.view.backgroundColor = canShowFirstModule ? .whiteColor() : .redColor()
        
        viewController.title = title
        viewController.output = presenter
        
        router.parentRouter = parentRouter                      //1
        router.transitionsHandler = transitionsHandler          //2
        router.detailTransitionsHandler = detailTransitionsHandler //3
        router.setRootViewControllerIfNeeded(viewController)    //4
            
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
        
    }
}