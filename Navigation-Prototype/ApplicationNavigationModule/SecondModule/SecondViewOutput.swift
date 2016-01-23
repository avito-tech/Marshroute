import Foundation

protocol SecondViewOutput: class {
    func next(sender sender: AnyObject, title: Int)
    func done()
    func userDidRequestTimerLaunch()
    func toModule1(sender sender: AnyObject)
}