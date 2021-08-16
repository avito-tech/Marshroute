import Foundation

typealias CategoryId = String

struct Category {
    let title: String
    let id: CategoryId
    let subcategories: [Category]?
}

protocol CategoriesProvider: AnyObject {
    func topCategory() -> Category
    func categoryForId(_ categoryId: CategoryId) -> Category
}
