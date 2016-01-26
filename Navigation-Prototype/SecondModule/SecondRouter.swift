import Foundation

protocol SecondRouter: RouterDismisable, RouterFocusable {
    func showFirstModule(sender sender: AnyObject)
    func showSecondModule(sender sender: AnyObject, title: Int)
}