import Foundation

protocol FirstRouter: Router {
    func showWhiteModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool)
    func showRedModule(count: Int, canShowFirstModule: Bool, canShowSecondModule: Bool)
    
    func showSecondModule(sender sender: AnyObject?)
}