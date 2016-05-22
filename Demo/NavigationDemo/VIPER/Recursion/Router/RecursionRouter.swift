import AvitoNavigation

protocol RecursionRouter: class, RouterDismissable, RouterFocusable {
    func showRecursion(sender: AnyObject)
    func showCategories(sender: AnyObject)
}
