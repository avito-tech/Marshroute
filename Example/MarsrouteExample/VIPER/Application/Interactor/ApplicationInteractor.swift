import Foundation

enum BannerType {
    case recursion
    case categories
}

protocol ApplicationInteractor: class {
    func bannerType(_ completion: ((_ bannerType: BannerType) -> ())?)
    func switchBannerType()
}
