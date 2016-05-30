import Foundation

class BaseAssembly {
    let assemblyFactory: AssemblyFactory
    let serviceFactory: ServiceFactory
    
    init(assemblyFactory: AssemblyFactory,
         serviceFactory: ServiceFactory)
    {
        self.assemblyFactory = assemblyFactory
        self.serviceFactory = serviceFactory
    }
}