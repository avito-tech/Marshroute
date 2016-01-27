import Foundation

protocol SecondRouter: Router {
    func showFirstModule(sender sender: AnyObject)
    func showSecondModule(sender sender: AnyObject, title: Int)
}