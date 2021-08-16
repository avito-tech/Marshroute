import Marshroute

protocol SearchResultsRouter: AnyObject {
    func showAdvertisement(searchResultId: SearchResultId)
    func showRecursion(sender: AnyObject)
}
