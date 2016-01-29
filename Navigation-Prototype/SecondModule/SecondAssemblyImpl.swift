import UIKit

final class SecondAssemblyImpl: SecondAssembly {
    
    func iphoneModule(
        transitionsHandler: TransitionsHandler,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?)
        -> (UIViewController, SecondModuleInput)
    {
        debugPrint("iphone 2")
        
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5, canShowModule1: canShowModule1)

        let router = SecondRouterImpl(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler)
        
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
        presentingTransitionsHandler: TransitionsHandler?)
        -> (UIViewController, SecondModuleInput)
    {
        debugPrint("ipad 2")
    
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5, canShowModule1: canShowModule1)

        let router = SecondRouterImpl_iPad(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler)
        
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