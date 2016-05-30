import Foundation

protocol AdvertisementCacher: class {
    func cache(advertisement advertisement: Advertisement)
    func cached(advertisementId advertisementId: AdvertisementId) -> Advertisement?
}
