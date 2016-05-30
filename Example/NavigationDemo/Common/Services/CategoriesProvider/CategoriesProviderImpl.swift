import Foundation

final class CategoriesProviderImpl: CategoriesProvider {
    // MARK: - CategoriesProvider
    func topCategory() -> Category {
        return Category(
            title: "categories.selectCategory".localized,
            id: "-1",
            subcategories: self.allCategories()
        )
    }
    
    func categoryForId(categoryId: CategoryId) -> Category {
        let allCategories = self.allCategoryDictionaries()
        return categoryForId(categoryId, inCategories: allCategories)!
    }
    
    // MARK: - Private
    private func allCategories() -> [Category] {
        let allCategories = self.allCategoryDictionaries()
        return allCategories.map { category(categoryDictionary: $0) }
    }
    
    private func allCategoryDictionaries() -> [[String: AnyObject]] {
        let path = NSBundle.mainBundle().pathForResource("Categories", ofType: "plist")
        return NSArray(contentsOfFile: path!) as! [[String: AnyObject]]
    }
    
    private func categoryForId(categoryId: String, inCategories categoryDictionaries:[[String: AnyObject]]) -> Category? {
        for categoryDictionary in categoryDictionaries {
            if let id = categoryDictionary["id"] as? CategoryId where id == categoryId {
                return category(categoryDictionary: categoryDictionary)
            }
            
            if let subCategoryDictionaries = categoryDictionary["subcategories"] as? [[String: AnyObject]] {
                if let result = categoryForId(categoryId, inCategories: subCategoryDictionaries) {
                    return result
                }
            }
        }
        return nil
    }
    
    private func category(categoryDictionary categoryDictionary: [String: AnyObject]) -> Category {
        return Category(
            title: categoryDictionary["title"] as! String,
            id: categoryDictionary["id"] as! CategoryId,
            subcategories: subcategories(categoryDictionaries: categoryDictionary["subcategories"] as? [[String: AnyObject]])
        )
    }
    
    private func subcategories(categoryDictionaries categoryDictionaries: [[String: AnyObject]]?) -> [Category]? {
        if let categoryDictionaries = categoryDictionaries {
            return categoryDictionaries.map { category(categoryDictionary: $0) }
        }
        return nil
    }
}
