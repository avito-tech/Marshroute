import Foundation

final class ApplicationInteractorImpl: ApplicationInteractor {
    fileprivate var bannerType: BannerType = .categories
    
    // MARK: - ApplicationInteractor
    func bannerType(_ completion: ((_ bannerType: BannerType) -> ())?) {
        completion?(bannerType)
    }
    
    func switchBannerType() {
        switch bannerType {
        case .categories:
            bannerType = .recursion
        
        case .recursion:
            bannerType = .categories
        }
    }
}
