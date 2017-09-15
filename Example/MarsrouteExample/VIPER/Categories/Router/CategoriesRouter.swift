import Marshroute

protocol CategoriesRouter: class, RouterDismissable {
    func showSubcategories(categoryId: CategoryId)
    func showSearchResults(categoryId: CategoryId)
    func returnToCategories()
}
