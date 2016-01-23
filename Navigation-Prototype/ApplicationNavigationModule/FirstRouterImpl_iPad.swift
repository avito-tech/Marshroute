import Foundation

final class FirstRouterImpl_iPad: MasterRouter {}

extension FirstRouterImpl_iPad: FirstRouter {
    func showWhiteModule(count: Int, moduleChangeable: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().module(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: transitionsHandler,
            detailTransitionsHandler: detailTransitionsHandler,
            moduleChangeable: moduleChangeable).0
        
        pushViewController(viewController)
    }
    
    func showRedModule(count: Int, moduleChangeable: Bool) {
        let viewController = AssemblyFactory.firstModuleAssembly().module(
            String(count + 1),
            parentRouter: self,
            transitionsHandler: detailTransitionsHandler,
            moduleChangeable: moduleChangeable).0
        
        setDetailViewController(viewController)
    }
}