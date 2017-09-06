import UIKit

public protocol TransitionsHandlersProviderHolder: class {
    var transitionsHandlersProvider: TransitionsHandlersProvider { get }
}
