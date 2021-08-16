import Foundation

enum BannerType {
    case recursion
    case categories
}

protocol ApplicationInteractor: AnyObject {
    func bannerType(_ completion: ((_ bannerType: BannerType) -> ())?)
    func switchBannerType()
}
