import Foundation

typealias CategoryId = String

struct Category {
    let title: String
    let id: CategoryId
    let subCategories: [Category]?
}

protocol CategoriesProvider: class {
    func topCategory() -> Category
    func categoryForId(categoryId: CategoryId) -> Category
}