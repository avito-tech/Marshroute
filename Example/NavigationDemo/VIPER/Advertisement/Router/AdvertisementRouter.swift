import Marshroute

protocol AdvertisementRouter: AnyObject {
    func showSimilarSearchResult(searchResultId: SearchResultId)
    func showRecursion(sender: AnyObject)
}
