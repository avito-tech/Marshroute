import Marshroute

protocol RecursionRouter: RouterDismissable, RouterFocusable {
    func showRecursion(sender: AnyObject)
    func showCategories(sender: AnyObject)
}
