class AssemblyFactory {
    static func applicationNavigationModuleAssembly() -> ApplicationNavigationModuleAssembly {
        return ApplicationNavigationModuleAssemblyImpl()
    }
    
    static func firstModuleAssembly() -> FirstAssembly {
        return FirstAssemblyImpl()
    }
    
}
