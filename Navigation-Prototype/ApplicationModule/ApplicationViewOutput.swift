import UIKit

enum ApplicationTabs: Int {
    case One
    case Two
    case Three
}

protocol ApplicationViewOutput: class {
    func viewDidRunOutOfMemory()
    func userDidAskTab(tab: ApplicationTabs)
}