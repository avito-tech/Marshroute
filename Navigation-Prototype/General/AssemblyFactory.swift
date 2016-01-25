class AssemblyFactory {
    static func applicationModuleAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl()
    }
    
    static func applicationNavigationModuleAssembly() -> ApplicationNavigationAssembly {
        return ApplicationNavigationAssemblyImpl()
    }
    
    static func firstModuleAssembly() -> FirstAssembly {
        return FirstAssemblyImpl()
    }
    
    static func secondModuleAssembly() -> SecondAssembly {
        return SecondAssemblyImpl()
    }
    
}
