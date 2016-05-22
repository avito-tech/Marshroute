import AvitoNavigation

protocol CategoriesRouter: class, RouterDismissable {
    func showSubCategories(categoryId categoryId: CategoryId)
    func showSearchResults(categoryId categoryId: CategoryId)
    func returnToCategories()
}
