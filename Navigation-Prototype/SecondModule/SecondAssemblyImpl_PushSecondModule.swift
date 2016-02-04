import UIKit

final class SecondAssemblyImpl_PushSecondModule: SecondAssembly {
    
    func iphoneModule(
        transitionsHandler: TransitionsHandler,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator)
        -> (UIViewController, SecondModuleInput)
    {
        debugPrint("iphone 2 - \(transitionId)")
        
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5, canShowModule1: canShowModule1)

        let router = SecondRouterImpl_PushSecondModule(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator)
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = SecondViewController(
            presenter: presenter,
            dismissable: presentingTransitionsHandler != nil,
            canShowModule1: canShowModule1
        )
        viewController.view.backgroundColor = .yellowColor()
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
    
    func ipadModule(
        transitionsHandler: TransitionsHandler,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator)
        -> (UIViewController, SecondModuleInput)
    {
        debugPrint("ipad 2 - \(transitionId)")
    
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5, canShowModule1: canShowModule1)

        let router = SecondRouterImpl_iPad_PushSecondModule(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator)
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = SecondViewController(
            presenter: presenter,
            dismissable: presentingTransitionsHandler != nil,
            canShowModule1: canShowModule1
        )
        viewController.view.backgroundColor = .yellowColor()
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return (viewController, presenter)
    }
}