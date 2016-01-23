import Foundation

protocol SecondRouter: RouterDismisable {
    func showFirstModule(sender sender: AnyObject)
    func dismissChildModules()
    func showSecondModule(sender sender: AnyObject, title: Int)
}