import UIKit

final class FirstAssemblyImpl: FirstAssembly {
    
    func iphoneModule(
        title title: String,
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
       {
        debugPrint("iphone 1 - \(routerSeed.transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl(routerSeed: routerSeed)
        
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
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    {
        debugPrint("ipad detail 1 - \(routerSeed.transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_iPad(routerSeed: routerSeed)
        
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
        canShowFirstModule: Bool,
        canShowSecondModule: Bool,
        dismissable: Bool,
        withTimer: Bool,
        routerSeed: BaseRouterSeed,
        detailTransitionsHandlerBox: RouterTransitionsHandlerBox)
        -> UIViewController
    {
        debugPrint("ipad master 1 - \(routerSeed.transitionId)")
        
        let interactor = FirstInteractorImpl(canShowFirstModule: canShowFirstModule, canShowSecondModule: canShowSecondModule, withTimer: withTimer, timerSeconds: 5)
        
        let router = FirstRouterImpl_iPadMasterDetail(
            routerSeed: routerSeed,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox)
        
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