import Foundation

protocol BannerModuleInput: class {
    func setTitle(title: String)
    func setPresented()
    
    var onBannerTap: (() -> ())? { get set }
    var onBannerTimeout: (() -> ())? { get set }
}
