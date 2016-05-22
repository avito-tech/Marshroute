import Foundation

protocol AssemblyFactory: class {
    func applicationAssembly() -> ApplicationAssembly

    func categoriesAssembly() -> CategoriesAssembly
    
    func subCategoriesAssembly() -> SubCategoriesAssembly
    
    func searchResultsAssembly() -> SearchResultsAssembly
    
    func advertisementAssembly() -> AdvertisementAssembly
    
    func recursionAssembly() -> RecursionAssembly
    
    func shelfAssembly() -> ShelfAssembly
    
    func authorizationAssembly() -> AuthorizationAssembly
    
    func bannerAssembly() -> BannerAssembly
}
