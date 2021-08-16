import Foundation

protocol AdvertisementCacher: AnyObject {
    func cache(advertisement: Advertisement)
    func cached(advertisementId: AdvertisementId) -> Advertisement?
}
