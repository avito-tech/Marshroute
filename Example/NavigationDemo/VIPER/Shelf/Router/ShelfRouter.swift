import Marshroute

protocol ShelfRouter: RouterDismissable {
    func showShelf(
        style: ShelfStyle,
        configure: (ShelfModule) -> ())
}
