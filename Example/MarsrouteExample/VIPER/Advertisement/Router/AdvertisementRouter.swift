import Marshroute

protocol AdvertisementRouter: class {
    func showSimilarSearchResult(searchResultId: SearchResultId)
    func showRecursion(sender: AnyObject)
}
