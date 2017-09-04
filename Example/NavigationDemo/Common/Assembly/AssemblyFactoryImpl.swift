import Marshroute

final class AssemblyFactoryImpl: AssemblyFactory {
    // MARK: - Init
    private let serviceFactory: ServiceFactory
    private let marshrouteStack: MarshrouteStack
    
    init(
        serviceFactory: ServiceFactory,
        marshrouteStack: MarshrouteStack)
    {
        self.serviceFactory = serviceFactory
        self.marshrouteStack = marshrouteStack
    }
    
    // MARK: - AssemblyFactory
    func applicationAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func categoriesAssembly() -> CategoriesAssembly {
        return CategoriesAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func subcategoriesAssembly() -> SubcategoriesAssembly {
        return CategoriesAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func searchResultsAssembly() -> SearchResultsAssembly {
        return SearchResultsAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func advertisementAssembly() -> AdvertisementAssembly {
        return AdvertisementAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func recursionAssembly() -> RecursionAssembly {
        return RecursionAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func shelfAssembly() -> ShelfAssembly {
        return ShelfAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func authorizationAssembly() -> AuthorizationAssembly {
        return AuthorizationAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    func bannerAssembly() -> BannerAssembly {
        return BannerAssemblyImpl(assemblySeed: assemblySeed)
    }
    
    // MARK: - Private
    private var assemblySeed: BaseAssemblySeed {
        return BaseAssemblySeed(
            assemblyFactory: self,
            serviceFactory: serviceFactory,
            marshrouteStack: marshrouteStack
        )
    }
}
