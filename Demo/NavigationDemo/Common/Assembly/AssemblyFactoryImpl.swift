final class AssemblyFactoryImpl: AssemblyFactory {
    // MARK: - Init
    private let serviceFactory: ServiceFactory
    
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    // MARK: - AssemblyFactory
    func applicationAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func categoriesAssembly() -> CategoriesAssembly {
        return CategoriesAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func subCategoriesAssembly() -> SubCategoriesAssembly {
        return CategoriesAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func searchResultsAssembly() -> SearchResultsAssembly {
        return SearchResultsAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func advertisementAssembly() -> AdvertisementAssembly {
        return AdvertisementAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func recursionAssembly() -> RecursionAssembly {
        return RecursionAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func shelfAssembly() -> ShelfAssembly {
        return ShelfAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func authorizationAssembly() -> AuthorizationAssembly {
        return AuthorizationAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
    
    func bannerAssembly() -> BannerAssembly {
        return BannerAssemblyImpl(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }
}