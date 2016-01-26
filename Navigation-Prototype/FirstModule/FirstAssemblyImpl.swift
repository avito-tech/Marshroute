import Foundation

final class FirstAssemblyImpl: FirstAssembly {
    
    func iphoneModule(
        title: String,
        parentTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId?,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    {
        debugPrint("iphone 1")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            parentTransitionsHandler: parentTransitionsHandler)
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter,
            dismissable: dismissable,
            withTimer: withTimer
        )
        viewController.view.backgroundColor = canShowFirstModule ? .whiteColor() : .redColor()
        viewController.title = title
        viewController.output = presenter
        
        router.setRootViewControllerIfNeeded(viewController)    //1
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
    
    func ipadDetailModule(
        title: String,
        parentTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId?,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    {
        debugPrint("ipad detail 1")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_IpadDetail(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            parentTransitionsHandler: parentTransitionsHandler)
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter,
            dismissable: dismissable,
            withTimer: withTimer
        )
        viewController.view.backgroundColor = canShowFirstModule ? .whiteColor() : .redColor()
        viewController.title = title
        viewController.output = presenter
        
        router.setRootViewControllerIfNeeded(viewController)    //1
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
    
    func ipadMasterModule(
        title: String,
        parentTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId?,
        transitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    {
        debugPrint("ipad master 1")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_iPadMaster(
            transitionsHandler: transitionsHandler,
            detailTransitionsHandler: detailTransitionsHandler,
            transitionId: transitionId,
            parentTransitionsHandler: parentTransitionsHandler)
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter,
            dismissable: dismissable,
            withTimer: withTimer
        )
        viewController.view.backgroundColor = canShowFirstModule ? .whiteColor() : .redColor()
        viewController.title = title
        viewController.output = presenter
        
        router.setRootViewControllerIfNeeded(viewController)        //1
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
}