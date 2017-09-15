import Foundation

protocol AdvertisementCacher: class {
    func cache(advertisement: Advertisement)
    func cached(advertisementId: AdvertisementId) -> Advertisement?
}
