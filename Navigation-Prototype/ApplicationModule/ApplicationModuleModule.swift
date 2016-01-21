import UIKit

struct ApplicationModuleModule {
    typealias ModuleInputType = ApplicationModuleModuleInput
    
    let view: UIView?
    let moduleInput: ApplicationModuleModuleInput?
    let viewController: UIViewController?
    
    //MARK: - Init
    init(view: UIView?, viewController: UIViewController?, moduleInput: ApplicationModuleModuleInput?) {
        self.view = view
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
    
}
