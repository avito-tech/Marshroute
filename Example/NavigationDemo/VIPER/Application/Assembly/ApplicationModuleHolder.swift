import UIKit

final class ApplicationModuleHolder {
    var applicationModule: AssembledMarshrouteModule<UITabBarController, ApplicationModule>?
    
    static let instance = ApplicationModuleHolder()
}
