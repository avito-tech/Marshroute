import Foundation
import Marshroute

class BaseDemoMasterDetailRouter: BaseMasterDetailRouter {
    let assemblyFactory: AssemblyFactory
    
    init(assemblyFactory: AssemblyFactory, routerSeed: MasterDetailRouterSeed) {
        self.assemblyFactory = assemblyFactory
        
        super.init(routerSeed: routerSeed)
    }
}
