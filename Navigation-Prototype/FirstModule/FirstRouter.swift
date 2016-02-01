import Foundation

protocol FirstRouter: class, RouterDismisable, RouterFocusable {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool)
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool)
    
    func showSecondModule(sender sender: AnyObject?)
    
    func showSecondModuleIfAuthorizationSucceeds()
}