class AssemblyFactory {
    static func applicationModuleAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl()
    }
    
    static func firstModuleAssembly() -> FirstAssembly {
        return FirstAssemblyImpl()
    }
    
    static func secondModuleAssembly() -> SecondAssembly {
        return SecondAssemblyImpl()
    }
 
    static func authModuleAssembly() -> AuthorizationAssembly {
        return AuthorizationAssemblyImpl()
    }
}
