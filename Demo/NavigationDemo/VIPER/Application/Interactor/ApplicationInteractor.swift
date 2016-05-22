import Foundation

enum BannerType {
    case Recursion
    case Categories
}

protocol ApplicationInteractor: class {
    func bannerType(completion: ((bannerType: BannerType) -> ())?)
    func switchBannerType()
}