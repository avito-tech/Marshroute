class AssemblyFactory {
    static func applicationNavigationModuleAssembly() -> ApplicationNavigationModuleAssembly {
        return ApplicationNavigationModuleAssemblyImpl()
    }
    
    static func firstModuleAssembly() -> FirstAssembly {
        return FirstAssemblyImpl()
    }
    
    static func secondModuleAssembly() -> SecondAssembly {
        return SecondAssemblyImpl()
    }
    
}
