import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedWithArgument(_ arg: CVarArg) -> String {
        let format = self.localized
        return NSString(format: format as NSString, arg) as String
    }
    
}
