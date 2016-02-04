final class AssemblyFactory {
    static func applicationModuleAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl()
    }
    
    static func firstModuleAssembly() -> FirstAssembly {
        return FirstAssemblyImpl()
    }
    
    static func secondModuleAssembly() -> SecondAssembly {
        return
            SecondAssemblyImpl()
            //SecondAssemblyImpl_PushSecondModule()
    }
 
    static func authModuleAssembly() -> AuthorizationAssembly {
        return AuthorizationAssemblyImpl()
    }
}
