import Marshroute

protocol SearchResultsRouter: class {
    func showAdvertisement(searchResultId: SearchResultId)
    func showRecursion(sender: AnyObject)
}
