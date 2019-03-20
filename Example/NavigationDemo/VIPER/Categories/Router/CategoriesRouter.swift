import Marshroute

protocol CategoriesRouter: RouterDismissable {
    func showSubcategories(categoryId: CategoryId)
    func showSearchResults(categoryId: CategoryId)
    func returnToCategories()
}
