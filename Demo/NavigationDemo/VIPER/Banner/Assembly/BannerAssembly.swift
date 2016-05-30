import UIKit
import AvitoNavigation

protocol BannerAssembly: class {
    func module() -> (view: UIView, moduleInput: BannerModuleInput)
}
