import UIKit

struct PeekAndPopData {
    weak var peekViewController: UIViewController?
    weak var sourceViewController: UIViewController?
    let popAction: (() -> ())
}
