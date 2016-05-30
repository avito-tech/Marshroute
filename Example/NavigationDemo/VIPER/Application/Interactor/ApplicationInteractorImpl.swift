import Foundation

final class ApplicationInteractorImpl: ApplicationInteractor {
    private var bannerType: BannerType = .Categories
    
    // MARK: - ApplicationInteractor
    func bannerType(completion: ((bannerType: BannerType) -> ())?) {
        completion?(bannerType: bannerType)
    }
    
    func switchBannerType() {
        switch bannerType {
        case .Categories:
            bannerType = .Recursion
        
        case .Recursion:
            bannerType = .Categories
        }
    }
}
