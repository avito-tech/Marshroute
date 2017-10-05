import UIKit
import Marshroute

struct AssembledMarshrouteModule<ViewController: UIViewController, Module> {
    let viewController: ViewController
    let interface: Module
    let disposeBag: DisposeBag
    let routerSeed: RouterSeed
    
    func assembledModule() -> AssembledModule<ViewController, Module> {
        return AssembledModule(
            view: viewController,
            interface: interface,
            disposeBag: disposeBag
        )
    }
    
    func assembledViewControllerModule() -> AssembledViewControllerModule<Module> {
        return AssembledViewControllerModule(
            viewController: viewController,
            interface: interface,
            disposeBag: disposeBag
        )
    }
}
