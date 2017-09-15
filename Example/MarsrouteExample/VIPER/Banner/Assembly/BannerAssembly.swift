import UIKit
import Marshroute

protocol BannerAssembly: class {
    func module() -> (view: UIView, moduleInput: BannerModuleInput)
}
