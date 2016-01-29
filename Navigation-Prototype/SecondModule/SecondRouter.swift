import Foundation

protocol SecondRouter: class, RouterDismisable, RouterFocusable {
    func showFirstModule(sender sender: AnyObject)
    func showSecondModule(sender sender: AnyObject, title: Int)
}