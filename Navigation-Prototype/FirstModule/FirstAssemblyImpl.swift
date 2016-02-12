import UIKit

final class FirstAssemblyImpl: FirstAssembly {
    
    func iphoneModule(
        title title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    {
        debugPrint("iphone 1 - \(transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
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
        
        return viewController
    }
    
    func ipadDetailModule(
        title title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    {
        debugPrint("ipad detail 1 - \(transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_iPad(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
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
        
        return viewController
    }
    
    func ipadMasterModule(
        title title: String,
        presentingTransitionsHandler: TransitionsHandler?,
        transitionId: TransitionId,
        transitionsHandlerBox: RouterTransitionsHandlerBox,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        transitionsCoordinator: TransitionsCoordinator,
        transitionIdGenerator: TransitionIdGenerator)
        -> UIViewController
    {
        debugPrint("ipad master 1 - \(transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_iPadMasterDetail(
            masterTransitionsHandlerBox: transitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: presentingTransitionsHandler,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
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
        
        return viewController
    }
}