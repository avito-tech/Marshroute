import UIKit

final class SecondAssemblyImpl: SecondAssembly {
    func iphoneModule(
        title title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    {
        debugPrint("iphone 2 - \(routerSeed.transitionId)")
        
        let interactor = SecondInteractorImpl(
            withTimer: withTimer,
            timerSeconds: 5,
            canShowModule1: canShowModule1
        )

        let router = SecondRouterImpl(routerSeed: routerSeed)
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let dismissable = routerSeed.presentingTransitionsHandler != nil
        let viewController = SecondViewController(
            presenter: presenter,
            dismissable: dismissable,
            canShowModule1: canShowModule1
        )
        
        viewController.view.backgroundColor = UIColor.yellowColor()
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return viewController
    }
    
    func ipadModule(
        title title: String,
        withTimer: Bool,
        canShowModule1: Bool,
        routerSeed: BaseRouterSeed)
        -> UIViewController
    {
        debugPrint("ipad 2 - \(routerSeed.transitionId)")
    
        let interactor = SecondInteractorImpl(
            withTimer: withTimer,
            timerSeconds: 5,
            canShowModule1: canShowModule1
        )

        let router = SecondRouterImpl_iPad(routerSeed: routerSeed)
        
        let presenter = SecondPresenter(
            interactor: interactor,
            router: router
        )
        
        let dismissable = routerSeed.presentingTransitionsHandler != nil
        let viewController = SecondViewController(
            presenter: presenter,
            dismissable: dismissable,
            canShowModule1: canShowModule1
        )
        viewController.view.backgroundColor = UIColor.yellowColor()
        viewController.title = title
        viewController.output = presenter
        
        presenter.viewInput = viewController
        interactor.output = presenter
        
        return viewController
    }
}