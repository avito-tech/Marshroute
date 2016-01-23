import Foundation

protocol SecondRouter: RouterDismisable {
    func showSecondModule(sender sender: AnyObject, title: Int)
    func dismissChildModules()
}