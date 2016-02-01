import Foundation

final class FirstAssemblyImpl: FirstAssembly {
    
    func iphoneModule(
        title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    {
        debugPrint("iphone 1 - \(transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler)
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter,
            dismissable: dismissable,
            withTimer: withTimer,
            canShowFirstModule: canShowFirstModule
        )
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
    
    func ipadDetailModule(
        title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    {
        debugPrint("ipad detail 1 - \(transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_IpadDetail(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler)
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter,
            dismissable: dismissable,
            withTimer: withTimer,
            canShowFirstModule: canShowFirstModule
        )
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
    
    func ipadMasterModule(
        title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool)
        -> (FirstViewController, FirstModuleInput)
    {
        debugPrint("ipad master 1 - \(transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_iPadMaster(
            masterTransitionsHandler: transitionsHandler,
            detailTransitionsHandler: detailTransitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler)
        
        let presenter = FirstPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = FirstViewController(
            presenter: presenter,
            dismissable: dismissable,
            withTimer: withTimer,
            canShowFirstModule: canShowFirstModule
        )
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
}