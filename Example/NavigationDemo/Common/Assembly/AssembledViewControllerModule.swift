import UIKit

struct AssembledViewControllerModule<Module> {
    let viewController: UIViewController
    let interface: Module
    let disposeBag: DisposeBag
    
    func assembledModule() -> AssembledModule<UIViewController, Module> {
        return AssembledModule(
            view: viewController,
            interface: interface,
            disposeBag: disposeBag
        )
    }
}
