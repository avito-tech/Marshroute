import Foundation

protocol SecondViewOutput: class {
    func next(sender sender: AnyObject, title: Int)
    func done()
    func userDidRequestTimerLaunch()
}