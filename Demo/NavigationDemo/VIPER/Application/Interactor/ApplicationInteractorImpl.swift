import Foundation

final class ApplicationInteractorImpl: ApplicationInteractor {
    private var bannerType: BannerType = .Recursion
    
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
