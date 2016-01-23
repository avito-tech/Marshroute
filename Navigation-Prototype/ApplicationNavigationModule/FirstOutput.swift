import Foundation

protocol FirstViewOutput: class {
    func onUserNextModule(count: Int)
    
    func onUserSecondModule(sender sender: AnyObject?)
    
    func onUserDone()
}
