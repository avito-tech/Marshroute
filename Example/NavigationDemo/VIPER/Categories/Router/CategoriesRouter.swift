import Marshroute

protocol CategoriesRouter: class, RouterDismissable {
    func showSubcategories(categoryId categoryId: CategoryId)
    func showSearchResults(categoryId categoryId: CategoryId)
    func returnToCategories()
}
