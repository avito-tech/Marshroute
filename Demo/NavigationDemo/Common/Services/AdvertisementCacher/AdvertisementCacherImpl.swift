import Foundation

final class AdvertisementCacherImpl: AdvertisementCacher {
    // MARK: - Private properties
    private var cache = [AdvertisementId: Advertisement]()
    
    // MARK: - AdvertisementCacher
    func cache(advertisement advertisement: Advertisement) {
        cache[advertisement.id] = advertisement
    }
    
    func cached(advertisementId advertisementId: AdvertisementId) -> Advertisement? {
        return cache[advertisementId]
    }
}