import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedWithArgument(arg: CVarArgType) -> String {
        let format = self.localized
        return NSString(format: format, arg) as String
    }
    
}
