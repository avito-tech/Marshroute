import AvitoNavigation

protocol SearchResultsRouter: class {
    func showAdvertisement(searchResultId searchResultId: SearchResultId)
    func showRecursion(sender: AnyObject)
}
