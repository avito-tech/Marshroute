import UIKit

final class ApplicationModuleHolder {
    static let instance = ApplicationModuleHolder()
    
    var applicationModule: (UIViewController, ApplicationModuleInput)?
}