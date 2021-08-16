import Foundation

protocol BannerModuleInput: AnyObject {
    func setTitle(_ title: String)
    func setPresented()
    
    var onBannerTap: (() -> ())? { get set }
    var onBannerTimeout: (() -> ())? { get set }
}
