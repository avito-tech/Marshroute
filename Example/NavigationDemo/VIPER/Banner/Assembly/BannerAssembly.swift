import UIKit
import Marshroute

protocol BannerAssembly: AnyObject {
    func module() -> (view: UIView, moduleInput: BannerModuleInput)
}
