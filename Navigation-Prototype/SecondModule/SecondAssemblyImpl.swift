import UIKit

final class SecondAssemblyImpl: SecondAssembly {
    
    func iphoneModule(
        transitionsHandlerBox transitionsHandlerBox: RouterTransitionsHandlerBox,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    {
        debugPrint("iphone 2 - \(transitionId)")
        
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5, canShowModule1: canShowModule1)

        let router = SecondRouterImpl(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
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
        
        return viewController
    }
    
    func ipadModule(
        transitionsHandlerBox transitionsHandlerBox: RouterTransitionsHandlerBox,
        title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        transitionId: TransitionId,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    {
        debugPrint("ipad 2 - \(transitionId)")
    
        let interactor = SecondInteractorImpl(withTimer: withTimer, timerSeconds: 5, canShowModule1: canShowModule1)

        let router = SecondRouterImpl_iPad(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
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
        
        return viewController
    }
}