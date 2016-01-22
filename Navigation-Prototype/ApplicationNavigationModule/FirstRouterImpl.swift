import Foundation

final class FirstRouterImpl: BaseRouter {}

extension FirstRouterImpl: FirstRouter {
    func showWhiteModule(count: Int, moduleChangeable: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().module(
            String(count),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            moduleChangeable: moduleChangeable).0
        
        pushViewController(viewController)
    }
    
    func showRedModule(count: Int, moduleChangeable: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().module(
            String(count),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            moduleChangeable: moduleChangeable).0
        
        pushViewController(viewController)
    }
}