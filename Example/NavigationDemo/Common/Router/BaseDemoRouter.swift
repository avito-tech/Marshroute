import Foundation
import AvitoNavigation

class BaseDemoRouter: BaseRouter {
    let assemblyFactory: AssemblyFactory
    
    init(assemblyFactory: AssemblyFactory, routerSeed: RouterSeed) {
        self.assemblyFactory = assemblyFactory
        
        super.init(routerSeed: routerSeed)
    }
}
