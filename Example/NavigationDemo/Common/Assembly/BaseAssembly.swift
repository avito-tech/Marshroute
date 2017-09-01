import Foundation
import Marshroute

class BaseAssembly {
    let assemblyFactory: AssemblyFactory
    let serviceFactory: ServiceFactory
    let marshrouteStack: MarshrouteStack
    
    init(assemblySeed: BaseAssemblySeed)
    {
        self.assemblyFactory = assemblySeed.assemblyFactory
        self.serviceFactory = assemblySeed.serviceFactory
        self.marshrouteStack = assemblySeed.marshrouteStack
    }
}
