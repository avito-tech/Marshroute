import UIKit

public protocol TransitionsHandlersProviderHolder: AnyObject {
    var transitionsHandlersProvider: TransitionsHandlersProvider { get }
}
